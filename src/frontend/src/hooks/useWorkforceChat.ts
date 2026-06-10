import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { type WorkforceMessage, mapBackendMessage } from "../organisms";
import { useActor } from "./useActor";

export function useWorkforceChat(threadId: string) {
  const { actor, isFetching } = useActor();
  const qc = useQueryClient();

  const threadQuery = useQuery<WorkforceMessage[]>({
    queryKey: ["thread", threadId],
    queryFn: async () => {
      if (!actor || !threadId) return [];
      const raw = await (actor as any).getWorkforceThread(threadId);
      return (raw as any[]).map(mapBackendMessage);
    },
    enabled: !!actor && !isFetching && !!threadId,
    staleTime: 5_000,
  });

  const sendMutation = useMutation({
    mutationFn: async ({
      organismId,
      message,
    }: {
      organismId: string;
      message: string;
    }): Promise<WorkforceMessage> => {
      if (!actor) throw new Error("No actor");
      const raw = await (actor as any).workforceChat(
        organismId,
        threadId,
        message,
      );
      return mapBackendMessage(raw);
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["thread", threadId] }),
  });

  return {
    messages: threadQuery.data ?? [],
    isLoading: sendMutation.isPending,
    sendMessage: sendMutation.mutateAsync,
  };
}
