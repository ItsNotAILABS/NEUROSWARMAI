import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  type ArtifactRecord,
  type Organism,
  type OrganismListing,
  mapBackendArtifact,
  mapBackendOrganism,
} from "../organisms";
import { useActor } from "./useActor";
import { useInternetIdentity } from "./useInternetIdentity";

export function useOrganisms() {
  const { actor, isFetching } = useActor();
  const { identity } = useInternetIdentity();
  const qc = useQueryClient();

  const principalKey = identity?.getPrincipal().toString() ?? "anon";

  const organismsQuery = useQuery<Organism[]>({
    queryKey: ["organisms", principalKey],
    queryFn: async () => {
      if (!actor || !identity) return [];
      const raw = await (actor as any).getMyOrganisms();
      return (raw as any[]).map(mapBackendOrganism);
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10_000,
  });

  const marketplaceQuery = useQuery<OrganismListing[]>({
    queryKey: ["marketplace"],
    queryFn: async () => {
      if (!actor) return [];
      const raw = await (actor as any).getMarketplaceListings();
      return (raw as any[]).map((l) => ({
        organism: mapBackendOrganism(l.organism),
        listedAt: Number(l.listedAt ?? 0),
      }));
    },
    enabled: !!actor && !isFetching,
    staleTime: 30_000,
  });

  const artifactsQuery = useQuery<ArtifactRecord[]>({
    queryKey: ["artifacts", principalKey],
    queryFn: async () => {
      if (!actor || !identity) return [];
      const raw = await (actor as any).getMyArtifacts();
      return (raw as any[]).map(mapBackendArtifact);
    },
    enabled: !!actor && !isFetching && !!identity,
    staleTime: 10_000,
  });

  const seedMutation = useMutation({
    mutationFn: async () => {
      if (!actor) throw new Error("No actor");
      await (actor as any).seedPrebuiltOrganisms();
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["organisms"] }),
  });

  const storeArtifactMutation = useMutation({
    mutationFn: async ({
      organismId,
      artifactType,
      title,
      content,
    }: {
      organismId: string;
      artifactType: string;
      title: string;
      content: string;
    }) => {
      if (!actor) throw new Error("No actor");
      return (actor as any).storeArtifact(
        organismId,
        artifactType,
        title,
        content,
      ) as Promise<string>;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["artifacts"] }),
  });

  return {
    organisms: organismsQuery.data ?? [],
    marketplace: marketplaceQuery.data ?? [],
    artifacts: artifactsQuery.data ?? [],
    isLoading: organismsQuery.isLoading,
    isMarketplaceLoading: marketplaceQuery.isLoading,
    refetchOrganisms: () => qc.invalidateQueries({ queryKey: ["organisms"] }),
    refetchMarketplace: () =>
      qc.invalidateQueries({ queryKey: ["marketplace"] }),
    refetchArtifacts: () => qc.invalidateQueries({ queryKey: ["artifacts"] }),
    seedOrganisms: seedMutation.mutateAsync,
    storeArtifact: storeArtifactMutation.mutateAsync,
    isSeedPending: seedMutation.isPending,
  };
}
