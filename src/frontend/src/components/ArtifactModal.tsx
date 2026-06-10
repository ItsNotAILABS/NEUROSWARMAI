import { Button } from "@/components/ui/button";
import { Copy, Download, X } from "lucide-react";
import { AnimatePresence, motion } from "motion/react";
import { useEffect, useRef } from "react";
import { toast } from "sonner";
import type { Artifact } from "../data/mockData";

interface ArtifactModalProps {
  artifact: Artifact | null;
  onClose: () => void;
}

function CodePreview({ artifact }: { artifact: Artifact }) {
  const lines = artifact.content.split("\n");
  return (
    <div className="bg-[oklch(10%_0.015_238)] rounded-lg border border-border overflow-hidden">
      <div className="flex items-center justify-between px-4 py-2 border-b border-border bg-surface">
        <span className="text-xs font-mono text-muted-foreground">
          {artifact.name}
        </span>
        <span className="text-[10px] uppercase tracking-wider text-primary font-mono">
          {artifact.language}
        </span>
      </div>
      <div className="overflow-auto max-h-[500px] p-4">
        <table className="w-full">
          <tbody>
            {lines.map((line, i) => (
              // biome-ignore lint/suspicious/noArrayIndexKey: line index is stable for code display
              <tr key={i} className="group">
                <td className="pr-4 text-right text-[11px] font-mono text-subtle-foreground w-8 select-none">
                  {i + 1}
                </td>
                <td className="text-xs font-mono text-foreground whitespace-pre">
                  {line}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

function PdfPreview({ artifact }: { artifact: Artifact }) {
  return (
    <div className="bg-surface rounded-lg border border-border p-8 text-center space-y-4">
      <div className="w-20 h-24 mx-auto rounded-lg bg-surface-elevated border border-border flex flex-col items-center justify-center gap-1">
        <div className="text-[10px] font-bold text-running uppercase tracking-widest">
          PDF
        </div>
        <div className="text-2xl font-bold text-foreground">
          {artifact.pages}
        </div>
        <div className="text-[10px] text-muted-foreground">pages</div>
      </div>
      <div>
        <h3 className="text-base font-semibold text-foreground">
          {artifact.name}
        </h3>
        <p className="text-sm text-muted-foreground mt-1">{artifact.content}</p>
        <p className="text-xs text-subtle-foreground mt-2">{artifact.size}</p>
      </div>
      <Button
        variant="outline"
        className="border-border text-muted-foreground hover:text-foreground"
      >
        <Download className="w-4 h-4 mr-2" />
        Download PDF
      </Button>
    </div>
  );
}

function CanvasPreview({ artifact }: { artifact: Artifact }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    canvas.width = canvas.offsetWidth * window.devicePixelRatio;
    canvas.height = canvas.offsetHeight * window.devicePixelRatio;
    ctx.scale(window.devicePixelRatio, window.devicePixelRatio);

    const w = canvas.offsetWidth;
    const h = canvas.offsetHeight;

    ctx.fillStyle = "#0B0F14";
    ctx.fillRect(0, 0, w, h);

    const nodes: { x: number; y: number; r: number; label: string }[] = [];
    const seed = [
      { x: 0.5, y: 0.5, r: 16, label: "CORE" },
      { x: 0.2, y: 0.25, r: 10, label: "NODE-1" },
      { x: 0.8, y: 0.2, r: 10, label: "NODE-2" },
      { x: 0.15, y: 0.65, r: 8, label: "SRV-A" },
      { x: 0.7, y: 0.7, r: 8, label: "SRV-B" },
      { x: 0.4, y: 0.85, r: 8, label: "SRV-C" },
      { x: 0.9, y: 0.55, r: 6, label: "N-12" },
      { x: 0.35, y: 0.15, r: 6, label: "N-34" },
    ];

    for (const n of seed) {
      nodes.push({ x: n.x * w, y: n.y * h, r: n.r, label: n.label });
    }

    const edges = [
      [0, 1],
      [0, 2],
      [0, 3],
      [0, 4],
      [0, 5],
      [1, 7],
      [2, 6],
      [3, 5],
      [4, 6],
    ];
    for (const [a, b] of edges) {
      const na = nodes[a];
      const nb = nodes[b];
      const grad = ctx.createLinearGradient(na.x, na.y, nb.x, nb.y);
      grad.addColorStop(0, "rgba(37,99,235,0.6)");
      grad.addColorStop(1, "rgba(14,165,183,0.3)");
      ctx.beginPath();
      ctx.moveTo(na.x, na.y);
      ctx.lineTo(nb.x, nb.y);
      ctx.strokeStyle = grad;
      ctx.lineWidth = 1.5;
      ctx.stroke();
    }

    for (const node of nodes) {
      const glow = ctx.createRadialGradient(
        node.x,
        node.y,
        0,
        node.x,
        node.y,
        node.r * 2.5,
      );
      glow.addColorStop(0, "rgba(37,99,235,0.25)");
      glow.addColorStop(1, "rgba(37,99,235,0)");
      ctx.beginPath();
      ctx.arc(node.x, node.y, node.r * 2.5, 0, Math.PI * 2);
      ctx.fillStyle = glow;
      ctx.fill();

      ctx.beginPath();
      ctx.arc(node.x, node.y, node.r, 0, Math.PI * 2);
      ctx.fillStyle =
        node.r > 12 ? "rgba(37,99,235,0.5)" : "rgba(14,165,183,0.3)";
      ctx.fill();
      ctx.strokeStyle =
        node.r > 12 ? "rgba(37,99,235,0.9)" : "rgba(14,165,183,0.7)";
      ctx.lineWidth = 1.5;
      ctx.stroke();

      ctx.fillStyle = "rgba(230,237,245,0.85)";
      ctx.font = `${node.r > 10 ? 10 : 8}px JetBrains Mono, monospace`;
      ctx.textAlign = "center";
      ctx.fillText(node.label, node.x, node.y + node.r + 12);
    }
  }, []);

  return (
    <div className="rounded-lg border border-border overflow-hidden">
      <div className="flex items-center justify-between px-4 py-2 border-b border-border bg-surface">
        <span className="text-xs font-mono text-muted-foreground">
          {artifact.name}
        </span>
        <span className="text-[10px] uppercase tracking-wider text-success font-mono">
          INTERACTIVE
        </span>
      </div>
      <canvas
        ref={canvasRef}
        className="w-full h-[420px] block"
        style={{ background: "#0B0F14" }}
      />
    </div>
  );
}

export function ArtifactModal({ artifact, onClose }: ArtifactModalProps) {
  const handleCopy = () => {
    if (artifact?.type === "code") {
      navigator.clipboard.writeText(artifact.content);
      toast.success("Code copied to clipboard");
    }
  };

  return (
    <AnimatePresence>
      {artifact && (
        <>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/60 backdrop-blur-sm z-40"
            onClick={onClose}
          />
          <motion.div
            data-ocid="artifact.modal"
            initial={{ opacity: 0, scale: 0.96, y: 8 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.96, y: 8 }}
            transition={{ duration: 0.2 }}
            className="fixed left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 z-50 w-full max-w-3xl max-h-[90vh] overflow-y-auto rounded-xl border border-border-strong bg-surface shadow-2xl"
          >
            <div className="flex items-center justify-between px-6 py-4 border-b border-border sticky top-0 bg-surface z-10">
              <div>
                <h2 className="text-base font-semibold text-foreground">
                  {artifact.name}
                </h2>
                <p className="text-xs text-muted-foreground capitalize mt-0.5">
                  {artifact.type} artifact
                </p>
              </div>
              <div className="flex items-center gap-2">
                {artifact.type === "code" && (
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={handleCopy}
                    className="border-border text-muted-foreground hover:text-foreground h-8"
                  >
                    <Copy className="w-3.5 h-3.5 mr-1.5" />
                    Copy
                  </Button>
                )}
                <button
                  type="button"
                  data-ocid="artifact.close_button"
                  onClick={onClose}
                  className="w-8 h-8 flex items-center justify-center rounded-md text-muted-foreground hover:text-foreground hover:bg-surface-elevated transition-colors"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
            </div>
            <div className="p-6">
              {artifact.type === "code" && <CodePreview artifact={artifact} />}
              {artifact.type === "pdf" && <PdfPreview artifact={artifact} />}
              {artifact.type === "canvas" && (
                <CanvasPreview artifact={artifact} />
              )}
            </div>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
