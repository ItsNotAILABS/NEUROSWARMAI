// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  GOVERNANCE CENTER — SOVEREIGN GOVERNANCE VISUALIZATION                                                   ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";
import { Slider } from "@/components/ui/slider";
import { Switch } from "@/components/ui/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import {
  AlertCircle,
  ArrowRight,
  BarChart3,
  Calendar,
  Check,
  CheckCircle,
  ChevronRight,
  Clock,
  FileText,
  Gavel,
  GitBranch,
  History,
  Loader2,
  MessageSquare,
  Pause,
  PieChart,
  Play,
  Plus,
  RefreshCw,
  Scale,
  Send,
  Settings,
  Shield,
  ThumbsDown,
  ThumbsUp,
  Timer,
  TrendingUp,
  Users,
  Vote,
  X,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";

import {
  GOVERNANCE_PARAMS,
  PRIORITY_COLORS,
  PRIORITY_LEVELS,
  PROPOSAL_STATUSES,
  PROPOSAL_STATUS_COLORS,
  PROPOSAL_TYPES,
  VOTE_TYPES,
  VOTE_TYPE_COLORS,
  calculateTimeRemaining,
  calculateVotingPower,
  formatVotingPower,
  getRequiredQuorum,
  getRequiredThreshold,
  getVotingPeriod,
  isProposalPassed,
  isQuorumMet,
} from "@/lib/governance/constants";

import type {
  PriorityLevel,
  ProposalStatus,
  ProposalType,
  VoteType,
} from "@/lib/governance/constants";

import type {
  CastVoteForm,
  CreateProposalForm,
  DelegationRecord,
  GovernanceAnalytics,
  GovernanceState,
  Proposal,
  ProposalSummary,
  VoteTally,
  VoterProfile,
} from "@/lib/governance/types";

// ═══════════════════════════════════════════════════════════════════════════════
// INITIALIZATION FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function generateId(): string {
  return Math.random().toString(36).substring(2, 15);
}

function initializeVoteTally(): VoteTally {
  const forVotes = Math.floor(Math.random() * 10000);
  const againstVotes = Math.floor(Math.random() * 5000);
  const abstainVotes = Math.floor(Math.random() * 1000);
  const total = forVotes + againstVotes + abstainVotes;

  return {
    forVotes,
    againstVotes,
    abstainVotes,
    totalVotes: total,
    uniqueVoters: Math.floor(total * 0.8),
    delegatedVotes: Math.floor(total * 0.3),
    quorumReached: Math.random() > 0.3,
    threshold: 0.67,
    thresholdMet: forVotes / (forVotes + againstVotes) > 0.67,
  };
}

function initializeProposal(index: number): Proposal {
  const type =
    PROPOSAL_TYPES[Math.floor(Math.random() * PROPOSAL_TYPES.length)];
  const status =
    PROPOSAL_STATUSES[Math.floor(Math.random() * PROPOSAL_STATUSES.length)];
  const priority =
    PRIORITY_LEVELS[Math.floor(Math.random() * PRIORITY_LEVELS.length)];
  const currentBeat = 5000 + Math.floor(Math.random() * 1000);

  return {
    id: generateId(),
    proposalNumber: index + 1,
    proposalType: type,
    status,
    priority,
    metadata: {
      title: `Proposal #${index + 1}: ${type} Update`,
      description: `This proposal aims to implement changes related to ${type.toLowerCase()}. The changes will affect the overall system behavior and governance parameters.`,
      summary: `Key changes for ${type}`,
      category: type,
      tags: [type.toLowerCase(), "governance", "update"],
      links: [],
      attachments: [],
    },
    actions: [],
    proposer: `proposer-${generateId()}`,
    proposerVotingPower: 1000 + Math.random() * 9000,
    sponsorsRequired: 0,
    sponsors: [],
    createdAt: Date.now() - Math.floor(Math.random() * 7 * 86400000),
    createdBeat: currentBeat - Math.floor(Math.random() * 1000),
    submittedAt: Date.now() - Math.floor(Math.random() * 5 * 86400000),
    votingStartBeat:
      status !== "Draft" && status !== "Pending" ? currentBeat - 500 : null,
    votingEndBeat:
      status !== "Draft" && status !== "Pending" ? currentBeat + 500 : null,
    executionBeat: status === "Executed" ? currentBeat : null,
    tally: initializeVoteTally(),
    votes: [],
    quorumRequired: getRequiredQuorum(type),
    thresholdRequired: getRequiredThreshold(type),
    executionDelay: 100,
    timeline: [],
    executedAt:
      status === "Executed"
        ? Date.now() - Math.floor(Math.random() * 86400000)
        : null,
    cancelledAt: null,
    cancelReason: null,
    vetoedBy: null,
    vetoedAt: null,
    vetoReason: null,
  };
}

function initializeVoterProfile(index: number): VoterProfile {
  const formaBalance = 100 + Math.random() * 50000;
  const stakedBalance = formaBalance * (0.3 + Math.random() * 0.5);
  const delegatedReceived = Math.random() > 0.7 ? Math.random() * 10000 : 0;
  const delegatedGiven = Math.random() > 0.8 ? Math.random() * 5000 : 0;

  return {
    principal: `voter-${generateId()}`,
    displayName: `Voter ${index + 1}`,
    formaBalance,
    stakedBalance,
    delegatedPowerReceived: delegatedReceived,
    delegatedPowerGiven: delegatedGiven,
    totalVotingPower: calculateVotingPower(
      formaBalance,
      stakedBalance,
      delegatedReceived - delegatedGiven,
    ),
    coherenceMultiplier: 0.8 + Math.random() * 0.4,
    roles: ["Citizen"],
    proposalsCreated: Math.floor(Math.random() * 5),
    proposalsVoted: Math.floor(Math.random() * 20),
    participationRate: 0.5 + Math.random() * 0.5,
    votingConsistency: 0.7 + Math.random() * 0.3,
    activeDelegationsReceived: Math.floor(delegatedReceived / 1000),
    activeDelegationsGiven: Math.floor(delegatedGiven / 1000),
    joinedAt: Date.now() - Math.floor(Math.random() * 365 * 86400000),
    lastVoteAt:
      Math.random() > 0.3
        ? Date.now() - Math.floor(Math.random() * 7 * 86400000)
        : null,
    lastProposalAt:
      Math.random() > 0.7
        ? Date.now() - Math.floor(Math.random() * 30 * 86400000)
        : null,
  };
}

function initializeGovernanceAnalytics(): GovernanceAnalytics {
  return {
    totalProposals: 47,
    activeProposals: 5,
    passedProposals: 32,
    rejectedProposals: 8,
    executedProposals: 30,
    totalVotesCast: 125000,
    uniqueVoters: 450,
    avgParticipationRate: 0.68,
    avgQuorumAchievement: 0.85,
    totalVotingPower: 10000000,
    topVotersPower: 3500000,
    medianVotingPower: 5000,
    giniCoefficient: 0.45,
    totalDelegations: 120,
    delegatedPowerRatio: 0.25,
    avgDelegationSize: 8000,
    avgVotingDuration: 2400,
    avgExecutionDelay: 150,
    metrics: [],
    proposalsOverTime: [],
    participationOverTime: [],
    votingPowerDistribution: [],
  };
}

function initializeGovernanceState(): GovernanceState {
  const proposals = Array.from({ length: 10 }, (_, i) => initializeProposal(i));
  const voters = Array.from({ length: 20 }, (_, i) =>
    initializeVoterProfile(i),
  );

  return {
    config: {
      votingPeriods: {
        Low: 500,
        Medium: 1000,
        High: 2000,
        Critical: 5000,
        Emergency: 500,
      },
      quorumRequirements: {} as any,
      thresholdRequirements: {} as any,
      executionDelays: {} as any,
      proposalThresholds: {} as any,
      maxActionsPerProposal: 10,
      maxActiveProposals: 100,
      maxDelegations: 10,
      delegationEnabled: true,
      vetoEnabled: true,
      emergencyActionsEnabled: true,
      guardians: [],
      updatedAt: Date.now(),
      updatedBy: "admin",
    },
    proposals,
    activeProposalIds: proposals
      .filter((p) => p.status === "Active")
      .map((p) => p.id),
    queuedProposalIds: proposals
      .filter((p) => p.status === "Queued")
      .map((p) => p.id),
    proposalCount: proposals.length,
    voters,
    voterCount: voters.length,
    totalVotingPower: voters.reduce((sum, v) => sum + v.totalVotingPower, 0),
    delegations: [],
    delegationNetwork: {
      nodes: [],
      edges: [],
      totalDelegations: 0,
      totalDelegatedPower: 0,
      avgDelegationChainLength: 0,
    },
    analytics: initializeGovernanceAnalytics(),
    recentActivity: {
      events: [],
      totalEvents: 0,
      hasMore: false,
      lastEventId: null,
    },
    currentBeat: 5500,
    lastUpdateBeat: 5500,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROPOSAL CARD COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface ProposalCardProps {
  proposal: Proposal;
  currentBeat: number;
  onVote: (proposalId: string) => void;
  onViewDetails: (proposalId: string) => void;
}

function ProposalCard({
  proposal,
  currentBeat,
  onVote,
  onViewDetails,
}: ProposalCardProps) {
  const timeRemaining = proposal.votingEndBeat
    ? calculateTimeRemaining(proposal.votingEndBeat, currentBeat)
    : null;

  const votingProgress =
    proposal.tally.totalVotes > 0
      ? (proposal.tally.forVotes /
          (proposal.tally.forVotes + proposal.tally.againstVotes)) *
        100
      : 0;

  const quorumProgress =
    proposal.quorumRequired > 0
      ? Math.min(
          100,
          (proposal.tally.uniqueVoters / (proposal.quorumRequired * 1000)) *
            100,
        )
      : 0;

  const canVote = proposal.status === "Active";

  return (
    <Card className="bg-background/95 border-border hover:border-primary/50 transition-colors">
      <CardHeader className="pb-2">
        <div className="flex items-start justify-between gap-2">
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-1">
              <Badge
                variant="outline"
                className="text-[10px]"
                style={{
                  borderColor: PROPOSAL_STATUS_COLORS[proposal.status],
                  color: PROPOSAL_STATUS_COLORS[proposal.status],
                }}
              >
                {proposal.status}
              </Badge>
              <Badge
                variant="outline"
                className="text-[10px]"
                style={{
                  borderColor: PRIORITY_COLORS[proposal.priority],
                  color: PRIORITY_COLORS[proposal.priority],
                }}
              >
                {proposal.priority}
              </Badge>
              <Badge variant="secondary" className="text-[10px]">
                {proposal.proposalType}
              </Badge>
            </div>
            <CardTitle className="text-sm font-semibold line-clamp-2">
              {proposal.metadata.title}
            </CardTitle>
          </div>
          <div className="text-right text-[10px] text-muted-foreground">
            #{proposal.proposalNumber}
          </div>
        </div>
      </CardHeader>
      <CardContent className="space-y-3">
        <p className="text-xs text-muted-foreground line-clamp-2">
          {proposal.metadata.summary}
        </p>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-[10px]">
            <span className="text-muted-foreground">Voting Progress</span>
            <span className="font-mono">
              {formatVotingPower(proposal.tally.forVotes)} For /{" "}
              {formatVotingPower(proposal.tally.againstVotes)} Against
            </span>
          </div>
          <div className="relative h-2 bg-surface rounded-full overflow-hidden">
            <div
              className="absolute left-0 top-0 h-full transition-all"
              style={{
                width: `${votingProgress}%`,
                backgroundColor: VOTE_TYPE_COLORS.For,
              }}
            />
            <div
              className="absolute right-0 top-0 h-full transition-all"
              style={{
                width: `${100 - votingProgress}%`,
                backgroundColor: VOTE_TYPE_COLORS.Against,
              }}
            />
          </div>
        </div>

        <div className="flex items-center justify-between text-[10px]">
          <div className="flex items-center gap-1">
            <Users className="w-3 h-3" />
            <span>{proposal.tally.uniqueVoters} voters</span>
          </div>
          {proposal.tally.quorumReached ? (
            <div className="flex items-center gap-1 text-green-500">
              <CheckCircle className="w-3 h-3" />
              <span>Quorum reached</span>
            </div>
          ) : (
            <div className="flex items-center gap-1 text-muted-foreground">
              <Clock className="w-3 h-3" />
              <span>{quorumProgress.toFixed(0)}% quorum</span>
            </div>
          )}
        </div>

        {timeRemaining && proposal.status === "Active" && (
          <div className="flex items-center justify-between text-[10px] p-2 rounded bg-surface">
            <div className="flex items-center gap-1 text-muted-foreground">
              <Timer className="w-3 h-3" />
              <span>Time remaining</span>
            </div>
            <span className="font-mono font-semibold">
              {timeRemaining.display}
            </span>
          </div>
        )}

        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            className="flex-1 text-xs"
            onClick={() => onViewDetails(proposal.id)}
          >
            Details
            <ChevronRight className="w-3 h-3 ml-1" />
          </Button>
          {canVote && (
            <Button
              size="sm"
              className="flex-1 text-xs"
              onClick={() => onVote(proposal.id)}
            >
              <Vote className="w-3 h-3 mr-1" />
              Vote
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROPOSAL LIST PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface ProposalListPanelProps {
  proposals: Proposal[];
  currentBeat: number;
  filterStatus: ProposalStatus | "all";
  onFilterChange: (status: ProposalStatus | "all") => void;
  onVote: (proposalId: string) => void;
  onViewDetails: (proposalId: string) => void;
}

function ProposalListPanel({
  proposals,
  currentBeat,
  filterStatus,
  onFilterChange,
  onVote,
  onViewDetails,
}: ProposalListPanelProps) {
  const filteredProposals =
    filterStatus === "all"
      ? proposals
      : proposals.filter((p) => p.status === filterStatus);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-sm font-semibold">Proposals</h2>
        <Select
          value={filterStatus}
          onValueChange={(v) => onFilterChange(v as any)}
        >
          <SelectTrigger className="w-32 h-8 text-xs">
            <SelectValue placeholder="Filter" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All</SelectItem>
            {PROPOSAL_STATUSES.map((status) => (
              <SelectItem key={status} value={status}>
                {status}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <ScrollArea className="h-[500px]">
        <div className="space-y-3 pr-4">
          {filteredProposals.map((proposal) => (
            <ProposalCard
              key={proposal.id}
              proposal={proposal}
              currentBeat={currentBeat}
              onVote={onVote}
              onViewDetails={onViewDetails}
            />
          ))}
          {filteredProposals.length === 0 && (
            <div className="text-center py-8 text-muted-foreground text-sm">
              No proposals found
            </div>
          )}
        </div>
      </ScrollArea>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// VOTING DIALOG
// ═══════════════════════════════════════════════════════════════════════════════

interface VotingDialogProps {
  proposal: Proposal | null;
  open: boolean;
  onClose: () => void;
  onVote: (
    proposalId: string,
    voteType: VoteType,
    reason: string | null,
  ) => void;
}

function VotingDialog({ proposal, open, onClose, onVote }: VotingDialogProps) {
  const [selectedVote, setSelectedVote] = useState<VoteType | null>(null);
  const [reason, setReason] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async () => {
    if (!proposal || !selectedVote) return;

    setIsSubmitting(true);
    await new Promise((r) => setTimeout(r, 1000));
    onVote(proposal.id, selectedVote, reason || null);
    setIsSubmitting(false);
    setSelectedVote(null);
    setReason("");
    onClose();
  };

  if (!proposal) return null;

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="text-base">Cast Your Vote</DialogTitle>
          <DialogDescription className="text-xs">
            {proposal.metadata.title}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4 py-4">
          <div className="grid grid-cols-3 gap-2">
            {VOTE_TYPES.map((voteType) => (
              <Button
                key={voteType}
                variant={selectedVote === voteType ? "default" : "outline"}
                className="flex flex-col items-center py-4"
                onClick={() => setSelectedVote(voteType)}
                style={{
                  backgroundColor:
                    selectedVote === voteType
                      ? VOTE_TYPE_COLORS[voteType]
                      : undefined,
                }}
              >
                {voteType === "For" && <ThumbsUp className="w-5 h-5 mb-1" />}
                {voteType === "Against" && (
                  <ThumbsDown className="w-5 h-5 mb-1" />
                )}
                {voteType === "Abstain" && <Scale className="w-5 h-5 mb-1" />}
                <span className="text-xs">{voteType}</span>
              </Button>
            ))}
          </div>

          <div className="space-y-2">
            <span className="text-xs text-muted-foreground">
              Reason (optional)
            </span>
            <Textarea
              placeholder="Why are you voting this way?"
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              className="text-sm"
              rows={3}
            />
          </div>

          <div className="bg-surface p-3 rounded-lg text-xs space-y-1">
            <div className="flex justify-between">
              <span className="text-muted-foreground">Your voting power</span>
              <span className="font-mono font-semibold">10,000 FORMA</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Required threshold</span>
              <span className="font-mono">
                {(proposal.thresholdRequired * 100).toFixed(0)}%
              </span>
            </div>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={onClose} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button
            onClick={handleSubmit}
            disabled={!selectedVote || isSubmitting}
          >
            {isSubmitting ? (
              <>
                <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                Submitting...
              </>
            ) : (
              <>
                <Send className="w-4 h-4 mr-2" />
                Submit Vote
              </>
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// ANALYTICS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface AnalyticsPanelProps {
  analytics: GovernanceAnalytics;
}

function AnalyticsPanel({ analytics }: AnalyticsPanelProps) {
  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <BarChart3 className="w-4 h-4" />
          Governance Analytics
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div className="bg-surface p-3 rounded-lg">
            <div className="text-[10px] text-muted-foreground">
              Total Proposals
            </div>
            <div className="text-lg font-mono font-semibold">
              {analytics.totalProposals}
            </div>
          </div>
          <div className="bg-surface p-3 rounded-lg">
            <div className="text-[10px] text-muted-foreground">Active</div>
            <div className="text-lg font-mono font-semibold text-blue-500">
              {analytics.activeProposals}
            </div>
          </div>
          <div className="bg-surface p-3 rounded-lg">
            <div className="text-[10px] text-muted-foreground">Passed</div>
            <div className="text-lg font-mono font-semibold text-green-500">
              {analytics.passedProposals}
            </div>
          </div>
          <div className="bg-surface p-3 rounded-lg">
            <div className="text-[10px] text-muted-foreground">Rejected</div>
            <div className="text-lg font-mono font-semibold text-red-500">
              {analytics.rejectedProposals}
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-3">
          <div className="flex justify-between items-center text-xs">
            <span className="text-muted-foreground">Participation Rate</span>
            <span className="font-mono font-semibold">
              {(analytics.avgParticipationRate * 100).toFixed(1)}%
            </span>
          </div>
          <Progress
            value={analytics.avgParticipationRate * 100}
            className="h-2"
          />
        </div>

        <div className="space-y-3">
          <div className="flex justify-between items-center text-xs">
            <span className="text-muted-foreground">Quorum Achievement</span>
            <span className="font-mono font-semibold">
              {(analytics.avgQuorumAchievement * 100).toFixed(1)}%
            </span>
          </div>
          <Progress
            value={analytics.avgQuorumAchievement * 100}
            className="h-2"
          />
        </div>

        <Separator />

        <div className="grid grid-cols-2 gap-2 text-[10px]">
          <div className="flex justify-between">
            <span className="text-muted-foreground">Total Votes Cast</span>
            <span className="font-mono">
              {formatVotingPower(analytics.totalVotesCast)}
            </span>
          </div>
          <div className="flex justify-between">
            <span className="text-muted-foreground">Unique Voters</span>
            <span className="font-mono">{analytics.uniqueVoters}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-muted-foreground">Total Delegations</span>
            <span className="font-mono">{analytics.totalDelegations}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-muted-foreground">Delegated Power</span>
            <span className="font-mono">
              {(analytics.delegatedPowerRatio * 100).toFixed(1)}%
            </span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// VOTER LEADERBOARD PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface VoterLeaderboardPanelProps {
  voters: VoterProfile[];
}

function VoterLeaderboardPanel({ voters }: VoterLeaderboardPanelProps) {
  const sortedVoters = useMemo(
    () =>
      [...voters]
        .sort((a, b) => b.totalVotingPower - a.totalVotingPower)
        .slice(0, 10),
    [voters],
  );

  const totalPower = voters.reduce((sum, v) => sum + v.totalVotingPower, 0);

  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Users className="w-4 h-4" />
          Top Voters
        </CardTitle>
        <CardDescription className="text-xs">
          By total voting power
        </CardDescription>
      </CardHeader>
      <CardContent>
        <ScrollArea className="h-48">
          <div className="space-y-2">
            {sortedVoters.map((voter, index) => (
              <div
                key={voter.principal}
                className="flex items-center gap-3 p-2 rounded bg-surface"
              >
                <div className="w-6 h-6 rounded-full bg-primary/20 flex items-center justify-center text-[10px] font-semibold">
                  {index + 1}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-xs font-semibold truncate">
                    {voter.displayName}
                  </div>
                  <div className="text-[10px] text-muted-foreground">
                    {voter.proposalsVoted} votes ·{" "}
                    {(voter.participationRate * 100).toFixed(0)}% participation
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-xs font-mono font-semibold">
                    {formatVotingPower(voter.totalVotingPower)}
                  </div>
                  <div className="text-[10px] text-muted-foreground">
                    {((voter.totalVotingPower / totalPower) * 100).toFixed(1)}%
                  </div>
                </div>
              </div>
            ))}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// GOVERNANCE OVERVIEW PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface GovernanceOverviewPanelProps {
  state: GovernanceState;
}

function GovernanceOverviewPanel({ state }: GovernanceOverviewPanelProps) {
  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Gavel className="w-4 h-4" />
          Governance Overview
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <FileText className="w-3 h-3" />
              <span>Active Proposals</span>
            </div>
            <div className="text-xl font-mono font-semibold">
              {state.activeProposalIds.length}
            </div>
          </div>
          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Users className="w-3 h-3" />
              <span>Total Voters</span>
            </div>
            <div className="text-xl font-mono font-semibold">
              {state.voterCount}
            </div>
          </div>
          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Zap className="w-3 h-3" />
              <span>Total Voting Power</span>
            </div>
            <div className="text-xl font-mono font-semibold">
              {formatVotingPower(state.totalVotingPower)}
            </div>
          </div>
          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Timer className="w-3 h-3" />
              <span>Current Beat</span>
            </div>
            <div className="text-xl font-mono font-semibold">
              {state.currentBeat}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CREATE PROPOSAL DIALOG
// ═══════════════════════════════════════════════════════════════════════════════

interface CreateProposalDialogProps {
  open: boolean;
  onClose: () => void;
  onCreate: (form: CreateProposalForm) => void;
}

function CreateProposalDialog({
  open,
  onClose,
  onCreate,
}: CreateProposalDialogProps) {
  const [form, setForm] = useState<CreateProposalForm>({
    proposalType: "ParameterChange",
    priority: "Medium",
    title: "",
    description: "",
    summary: "",
    category: "",
    tags: [],
    actions: [],
  });
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async () => {
    setIsSubmitting(true);
    await new Promise((r) => setTimeout(r, 1000));
    onCreate(form);
    setIsSubmitting(false);
    setForm({
      proposalType: "ParameterChange",
      priority: "Medium",
      title: "",
      description: "",
      summary: "",
      category: "",
      tags: [],
      actions: [],
    });
    onClose();
  };

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle className="text-base">Create Proposal</DialogTitle>
          <DialogDescription className="text-xs">
            Submit a new governance proposal for voting
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4 py-4 max-h-[60vh] overflow-y-auto">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <span className="text-xs text-muted-foreground">
                Proposal Type
              </span>
              <Select
                value={form.proposalType}
                onValueChange={(v) =>
                  setForm((f) => ({ ...f, proposalType: v as ProposalType }))
                }
              >
                <SelectTrigger className="h-9 text-xs">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {PROPOSAL_TYPES.map((type) => (
                    <SelectItem key={type} value={type}>
                      {type}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <span className="text-xs text-muted-foreground">Priority</span>
              <Select
                value={form.priority}
                onValueChange={(v) =>
                  setForm((f) => ({ ...f, priority: v as PriorityLevel }))
                }
              >
                <SelectTrigger className="h-9 text-xs">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {PRIORITY_LEVELS.map((level) => (
                    <SelectItem key={level} value={level}>
                      {level}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="space-y-2">
            <span className="text-xs text-muted-foreground">Title</span>
            <Input
              placeholder="Proposal title"
              value={form.title}
              onChange={(e) =>
                setForm((f) => ({ ...f, title: e.target.value }))
              }
              className="h-9 text-sm"
            />
          </div>

          <div className="space-y-2">
            <span className="text-xs text-muted-foreground">Summary</span>
            <Input
              placeholder="Brief summary"
              value={form.summary}
              onChange={(e) =>
                setForm((f) => ({ ...f, summary: e.target.value }))
              }
              className="h-9 text-sm"
            />
          </div>

          <div className="space-y-2">
            <span className="text-xs text-muted-foreground">Description</span>
            <Textarea
              placeholder="Detailed description of the proposal"
              value={form.description}
              onChange={(e) =>
                setForm((f) => ({ ...f, description: e.target.value }))
              }
              className="text-sm"
              rows={4}
            />
          </div>

          <div className="bg-surface p-3 rounded-lg text-xs space-y-2">
            <div className="font-semibold">Requirements</div>
            <div className="flex justify-between text-muted-foreground">
              <span>Required stake</span>
              <span className="font-mono">100 FORMA</span>
            </div>
            <div className="flex justify-between text-muted-foreground">
              <span>Voting period</span>
              <span className="font-mono">
                {getVotingPeriod(form.proposalType)} beats
              </span>
            </div>
            <div className="flex justify-between text-muted-foreground">
              <span>Required quorum</span>
              <span className="font-mono">
                {(getRequiredQuorum(form.proposalType) * 100).toFixed(0)}%
              </span>
            </div>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={onClose} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button
            onClick={handleSubmit}
            disabled={!form.title || !form.description || isSubmitting}
          >
            {isSubmitting ? (
              <>
                <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                Creating...
              </>
            ) : (
              <>
                <Plus className="w-4 h-4 mr-2" />
                Create Proposal
              </>
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function GovernanceCenter() {
  const [state, _setState] = useState<GovernanceState>(() =>
    initializeGovernanceState(),
  );
  const [filterStatus, setFilterStatus] = useState<ProposalStatus | "all">(
    "all",
  );
  const [selectedProposalId, setSelectedProposalId] = useState<string | null>(
    null,
  );
  const [votingDialogOpen, setVotingDialogOpen] = useState(false);
  const [createDialogOpen, setCreateDialogOpen] = useState(false);
  const [activeTab, setActiveTab] = useState("proposals");

  const selectedProposal = useMemo(
    () => state.proposals.find((p) => p.id === selectedProposalId) ?? null,
    [state.proposals, selectedProposalId],
  );

  const handleVote = useCallback((proposalId: string) => {
    setSelectedProposalId(proposalId);
    setVotingDialogOpen(true);
  }, []);

  const handleSubmitVote = useCallback(
    (proposalId: string, voteType: VoteType, reason: string | null) => {
      // Update state with new vote
      console.log("Vote submitted:", { proposalId, voteType, reason });
    },
    [],
  );

  const handleViewDetails = useCallback((proposalId: string) => {
    setSelectedProposalId(proposalId);
    setActiveTab("details");
  }, []);

  const handleCreateProposal = useCallback((form: CreateProposalForm) => {
    console.log("Create proposal:", form);
  }, []);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center">
            <Gavel className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-sm font-bold">Governance Center</h1>
            <p className="text-xs text-muted-foreground">
              {state.proposalCount} proposals · {state.voterCount} voters ·{" "}
              {formatVotingPower(state.totalVotingPower)} voting power
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Button size="sm" onClick={() => setCreateDialogOpen(true)}>
            <Plus className="w-4 h-4 mr-2" />
            New Proposal
          </Button>
          <Badge variant="outline">Beat #{state.currentBeat}</Badge>
        </div>
      </div>

      {/* Main content */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left panel - Overview */}
        <div className="w-80 border-r border-border p-4 overflow-y-auto space-y-4">
          <GovernanceOverviewPanel state={state} />
          <AnalyticsPanel analytics={state.analytics} />
        </div>

        {/* Center - Proposals */}
        <div className="flex-1 p-4 overflow-y-auto">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-3 mb-4">
              <TabsTrigger value="proposals" className="text-xs">
                Proposals
              </TabsTrigger>
              <TabsTrigger
                value="details"
                className="text-xs"
                disabled={!selectedProposal}
              >
                Details
              </TabsTrigger>
              <TabsTrigger value="history" className="text-xs">
                History
              </TabsTrigger>
            </TabsList>

            <TabsContent value="proposals" className="mt-0">
              <ProposalListPanel
                proposals={state.proposals}
                currentBeat={state.currentBeat}
                filterStatus={filterStatus}
                onFilterChange={setFilterStatus}
                onVote={handleVote}
                onViewDetails={handleViewDetails}
              />
            </TabsContent>

            <TabsContent value="details" className="mt-0">
              {selectedProposal ? (
                <Card className="bg-background/95 border-border">
                  <CardHeader>
                    <div className="flex items-start justify-between">
                      <div>
                        <div className="flex items-center gap-2 mb-2">
                          <Badge
                            variant="outline"
                            style={{
                              borderColor:
                                PROPOSAL_STATUS_COLORS[selectedProposal.status],
                              color:
                                PROPOSAL_STATUS_COLORS[selectedProposal.status],
                            }}
                          >
                            {selectedProposal.status}
                          </Badge>
                          <Badge variant="secondary">
                            {selectedProposal.proposalType}
                          </Badge>
                        </div>
                        <CardTitle className="text-lg">
                          {selectedProposal.metadata.title}
                        </CardTitle>
                        <CardDescription className="mt-2">
                          Proposed by{" "}
                          {selectedProposal.proposer.substring(0, 20)}...
                        </CardDescription>
                      </div>
                      <div className="text-right text-sm text-muted-foreground">
                        #{selectedProposal.proposalNumber}
                      </div>
                    </div>
                  </CardHeader>
                  <CardContent className="space-y-6">
                    <div>
                      <h3 className="text-sm font-semibold mb-2">
                        Description
                      </h3>
                      <p className="text-sm text-muted-foreground">
                        {selectedProposal.metadata.description}
                      </p>
                    </div>

                    <Separator />

                    <div>
                      <h3 className="text-sm font-semibold mb-2">
                        Voting Progress
                      </h3>
                      <div className="space-y-3">
                        <div className="grid grid-cols-3 gap-4 text-center">
                          <div className="bg-green-500/10 p-3 rounded-lg">
                            <div className="text-lg font-mono font-semibold text-green-500">
                              {formatVotingPower(
                                selectedProposal.tally.forVotes,
                              )}
                            </div>
                            <div className="text-xs text-muted-foreground">
                              For
                            </div>
                          </div>
                          <div className="bg-red-500/10 p-3 rounded-lg">
                            <div className="text-lg font-mono font-semibold text-red-500">
                              {formatVotingPower(
                                selectedProposal.tally.againstVotes,
                              )}
                            </div>
                            <div className="text-xs text-muted-foreground">
                              Against
                            </div>
                          </div>
                          <div className="bg-gray-500/10 p-3 rounded-lg">
                            <div className="text-lg font-mono font-semibold text-gray-500">
                              {formatVotingPower(
                                selectedProposal.tally.abstainVotes,
                              )}
                            </div>
                            <div className="text-xs text-muted-foreground">
                              Abstain
                            </div>
                          </div>
                        </div>

                        <div className="space-y-2">
                          <div className="flex justify-between text-xs">
                            <span>Quorum Progress</span>
                            <span>
                              {selectedProposal.tally.quorumReached
                                ? "Reached"
                                : "Not reached"}
                            </span>
                          </div>
                          <Progress
                            value={
                              selectedProposal.tally.quorumReached ? 100 : 50
                            }
                            className="h-2"
                          />
                        </div>
                      </div>
                    </div>

                    {selectedProposal.status === "Active" && (
                      <Button
                        className="w-full"
                        onClick={() => handleVote(selectedProposal.id)}
                      >
                        <Vote className="w-4 h-4 mr-2" />
                        Cast Your Vote
                      </Button>
                    )}
                  </CardContent>
                </Card>
              ) : (
                <div className="text-center py-12 text-muted-foreground">
                  Select a proposal to view details
                </div>
              )}
            </TabsContent>

            <TabsContent value="history" className="mt-0">
              <Card className="bg-background/95 border-border">
                <CardHeader>
                  <CardTitle className="text-sm font-semibold flex items-center gap-2">
                    <History className="w-4 h-4" />
                    Proposal History
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-sm text-muted-foreground text-center py-8">
                    Historical data will be displayed here
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>

        {/* Right panel - Voters */}
        <div className="w-72 border-l border-border p-4 overflow-y-auto space-y-4">
          <VoterLeaderboardPanel voters={state.voters} />
        </div>
      </div>

      {/* Dialogs */}
      <VotingDialog
        proposal={selectedProposal}
        open={votingDialogOpen}
        onClose={() => setVotingDialogOpen(false)}
        onVote={handleSubmitVote}
      />

      <CreateProposalDialog
        open={createDialogOpen}
        onClose={() => setCreateDialogOpen(false)}
        onCreate={handleCreateProposal}
      />
    </div>
  );
}

export default GovernanceCenter;
