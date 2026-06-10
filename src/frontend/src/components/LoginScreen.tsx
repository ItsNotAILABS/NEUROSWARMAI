import { Button } from "@/components/ui/button";
import { Loader2 } from "lucide-react";
import { motion } from "motion/react";
import { useInternetIdentity } from "../hooks/useInternetIdentity";

export function LoginScreen() {
  const { login, isLoggingIn } = useInternetIdentity();

  return (
    <div className="min-h-screen bg-background flex items-center justify-center relative overflow-hidden">
      {/* Ambient background glow */}
      <div className="absolute inset-0 pointer-events-none">
        <div
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] rounded-full opacity-[0.04]"
          style={{
            background:
              "radial-gradient(circle, oklch(62% 0.145 165) 0%, transparent 70%)",
          }}
        />
      </div>

      <motion.div
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.55, ease: "easeOut" }}
        className="w-full max-w-[400px] mx-4 flex flex-col items-center"
      >
        {/* Circular gradient logo mark */}
        <motion.div
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ delay: 0.1, duration: 0.45, ease: "easeOut" }}
          className="relative mb-7"
        >
          <div
            className="w-20 h-20 rounded-full flex items-center justify-center"
            style={{
              background:
                "conic-gradient(from 135deg, oklch(55% 0.145 165), oklch(70% 0.16 165), oklch(55% 0.145 165))",
              boxShadow:
                "0 0 40px oklch(62% 0.145 165 / 0.3), 0 0 80px oklch(62% 0.145 165 / 0.12)",
            }}
          >
            <span className="text-2xl font-black tracking-tighter text-background select-none">
              OCP
            </span>
          </div>
          {/* Outer ring */}
          <div
            className="absolute inset-0 rounded-full"
            style={{
              background: "transparent",
              border: "1px solid oklch(62% 0.145 165 / 0.3)",
              transform: "scale(1.14)",
            }}
          />
        </motion.div>

        {/* Title block */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.18, duration: 0.4 }}
          className="text-center mb-7"
        >
          <h1 className="text-xl font-black text-foreground tracking-[0.12em] uppercase mb-1.5">
            Organism Command Platform
          </h1>
          <p className="text-[11px] text-muted-foreground/70 tracking-widest uppercase">
            Sovereign AI Workforce&nbsp;·&nbsp;ICP Blockchain
          </p>
          <div className="inline-flex items-center gap-1.5 mt-3 px-2.5 py-1 rounded-full border border-border bg-surface">
            <div className="w-1.5 h-1.5 rounded-full bg-primary" />
            <span className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/70">
              Powered by Internet Computer
            </span>
          </div>
        </motion.div>

        {/* Card */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.26, duration: 0.4 }}
          className="w-full rounded-2xl border border-border bg-surface p-7"
        >
          <div className="space-y-5">
            <div>
              <h2 className="text-sm font-bold text-foreground tracking-tight">
                Sign in to your workspace
              </h2>
              <p className="text-xs text-muted-foreground mt-1 leading-relaxed">
                Authenticate with Internet Identity to access the Organism
                Command Platform.
              </p>
            </div>

            <Button
              data-ocid="login.primary_button"
              onClick={login}
              disabled={isLoggingIn}
              className="w-full h-11 font-bold tracking-wider text-sm bg-primary text-primary-foreground hover:bg-primary/90"
            >
              {isLoggingIn ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Signing in...
                </>
              ) : (
                "SIGN IN WITH INTERNET IDENTITY"
              )}
            </Button>

            <div className="flex items-center gap-2">
              <div className="flex-1 h-px bg-border/40" />
              <span className="text-[10px] text-muted-foreground/40 uppercase tracking-widest">
                Secured
              </span>
              <div className="flex-1 h-px bg-border/40" />
            </div>

            <p className="text-[10px] text-center text-muted-foreground/50">
              On-chain identity · No passwords · Blockchain-native
              authentication
            </p>
          </div>
        </motion.div>

        <p className="text-[10px] text-center text-muted-foreground/40 mt-6">
          © {new Date().getFullYear()}. Built with ♥ using{" "}
          <a
            href={`https://caffeine.ai?utm_source=caffeine-footer&utm_medium=referral&utm_content=${encodeURIComponent(window.location.hostname)}`}
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-primary transition-colors"
          >
            caffeine.ai
          </a>
        </p>
      </motion.div>
    </div>
  );
}
