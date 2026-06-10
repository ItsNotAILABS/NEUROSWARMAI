// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  GEO-RESONANCE PATTERN SCANNER — WORLD-SCALE FIELD SCANNER UI                                            ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THE ARCHITECTURE OF MEMORY IS THE ARCHITECTURE OF GEOGRAPHY                                             ║
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
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
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
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Activity,
  AlertTriangle,
  Antenna,
  Calendar,
  Compass,
  Database,
  Droplets,
  Eye,
  Globe,
  History,
  Layers,
  Loader2,
  MapPin,
  Moon,
  Mountain,
  Radio,
  RefreshCw,
  Satellite,
  Scale,
  Scan,
  Shield,
  Signal,
  Sun,
  Target,
  Waves,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";
import { type GRPEScanResult, useGRPE, useOrganismBrain } from "../hooks/useEnterprise";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// CONSTANTS — PHI-DERIVED THRESHOLDS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const PHI_INVERSE = 0.618033988749895; // φ⁻¹ = resonance threshold

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// HELPER COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface LayerScoreBarProps {
  label: string;
  value: number;
  icon: React.ReactNode;
  color: string;
}

const LayerScoreBar = ({ label, value, icon, color }: LayerScoreBarProps) => {
  const percentage = Math.min(value * 100, 100);
  const isHigh = value > PHI_INVERSE;
  
  return (
    <div className="space-y-1">
      <div className="flex items-center justify-between text-xs">
        <div className="flex items-center gap-2 text-muted-foreground">
          {icon}
          <span>{label}</span>
        </div>
        <span className={isHigh ? "text-primary font-medium" : "text-muted-foreground"}>
          {(value * 100).toFixed(1)}%
        </span>
      </div>
      <div className="h-2 bg-muted rounded-full overflow-hidden">
        <div
          className={`h-full rounded-full transition-all duration-500 ${color}`}
          style={{ width: `${percentage}%` }}
        />
      </div>
    </div>
  );
};

interface CalendarDisplayProps {
  label: string;
  value: string | number;
  icon: React.ReactNode;
  sublabel?: string;
}

const CalendarDisplay = ({ label, value, icon, sublabel }: CalendarDisplayProps) => (
  <div className="flex items-center gap-3 p-3 bg-muted/30 rounded-lg">
    <div className="p-2 bg-primary/10 rounded-lg">
      {icon}
    </div>
    <div>
      <p className="text-xs text-muted-foreground">{label}</p>
      <p className="text-sm font-medium">{value}</p>
      {sublabel && <p className="text-xs text-muted-foreground/60">{sublabel}</p>}
    </div>
  </div>
);

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// KNOWN LOCATIONS — SACRED SITES & STRATEGIC POINTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const KNOWN_LOCATIONS = [
  { name: "Great Pyramid of Giza", lat: 29.9792, lon: 31.1342, type: "sacred" },
  { name: "Teotihuacan", lat: 19.6925, lon: -98.8458, type: "sacred" },
  { name: "Stonehenge", lat: 51.1789, lon: -1.8262, type: "sacred" },
  { name: "Angkor Wat", lat: 13.4125, lon: 103.8670, type: "sacred" },
  { name: "Machu Picchu", lat: -13.1631, lon: -72.5450, type: "sacred" },
  { name: "Nazca Lines", lat: -14.7350, lon: -75.1300, type: "sacred" },
  { name: "Easter Island", lat: -27.1127, lon: -109.3497, type: "sacred" },
  { name: "Yucatan Peninsula (Cenotes)", lat: 20.5, lon: -87.5, type: "hydro" },
  { name: "South Atlantic Anomaly Center", lat: -29.0, lon: -60.0, type: "magnetic" },
  { name: "North Magnetic Pole", lat: 86.5, lon: -164.04, type: "magnetic" },
  { name: "Bermuda Triangle Center", lat: 25.0, lon: -71.0, type: "anomaly" },
];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface GeoResonanceScannerProps {
  className?: string;
}

export function GeoResonanceScanner({ className }: GeoResonanceScannerProps) {
  const {
    state,
    calendarState,
    layerScores,
    riskSummary,
    isLoading,
    isScanPending,
    runScan,
    setOperationalMode,
    lastScanResult,
    refetchAll,
  } = useGRPE();

  // Organism brain state for memory integration
  const {
    fullState: organismState,
    hz26State,
    lawEngineScore,
    vaelEngine,
    heritageState,
    runHeartbeat,
  } = useOrganismBrain();

  // Scan input state
  const [latitude, setLatitude] = useState<string>("29.9792");
  const [longitude, setLongitude] = useState<string>("31.1342");
  const [altitude, setAltitude] = useState<string>("0");
  const [selectedLocation, setSelectedLocation] = useState<string>("");
  const [scanHistory, setScanHistory] = useState<GRPEScanResult[]>([]);
  const [activeTab, setActiveTab] = useState("scanner");

  // Handle location selection
  const handleLocationSelect = (locationName: string) => {
    const location = KNOWN_LOCATIONS.find(l => l.name === locationName);
    if (location) {
      setLatitude(location.lat.toString());
      setLongitude(location.lon.toString());
      setAltitude("0");
      setSelectedLocation(locationName);
    }
  };

  // Handle scan
  const handleScan = async () => {
    const lat = parseFloat(latitude);
    const lon = parseFloat(longitude);
    const alt = parseFloat(altitude);
    
    if (isNaN(lat) || isNaN(lon) || isNaN(alt)) {
      console.error("Invalid coordinates");
      return;
    }

    try {
      const result = await runScan({ latitude: lat, longitude: lon, altitude: alt });
      setScanHistory(prev => [result, ...prev.slice(0, 9)]);
    } catch (e) {
      console.error("Scan failed:", e);
    }
  };

  // Get user's current location
  const handleGetCurrentLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setLatitude(position.coords.latitude.toFixed(6));
          setLongitude(position.coords.longitude.toFixed(6));
          setAltitude((position.coords.altitude || 0).toFixed(1));
          setSelectedLocation("");
        },
        (error) => {
          console.error("Geolocation error:", error);
        }
      );
    }
  };

  // Risk level color mapping
  const getRiskColor = (level: string) => {
    switch (level) {
      case "Critical": return "bg-red-500 text-red-50";
      case "High": return "bg-orange-500 text-orange-50";
      case "Medium": return "bg-yellow-500 text-yellow-900";
      case "Low": return "bg-green-500 text-green-50";
      default: return "bg-muted text-muted-foreground";
    }
  };

  return (
    <div className={`p-4 space-y-4 ${className}`}>
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Globe className="w-7 h-7 text-primary" />
            Geo-Resonance Scanner
          </h1>
          <p className="text-sm text-muted-foreground mt-1">
            World-scale electromagnetic field analysis • Defense • Infrastructure • Enterprise
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Button variant="outline" size="sm" onClick={refetchAll}>
            <RefreshCw className="w-4 h-4 mr-2" />
            Refresh
          </Button>
          {state && (
            <Badge variant="outline" className="font-mono">
              {state.totalScans} total scans
            </Badge>
          )}
        </div>
      </div>

      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList className="grid grid-cols-4 w-full max-w-lg">
          <TabsTrigger value="scanner" className="flex items-center gap-2">
            <Scan className="w-4 h-4" /> Scanner
          </TabsTrigger>
          <TabsTrigger value="layers" className="flex items-center gap-2">
            <Layers className="w-4 h-4" /> Layers
          </TabsTrigger>
          <TabsTrigger value="calendars" className="flex items-center gap-2">
            <Calendar className="w-4 h-4" /> Calendars
          </TabsTrigger>
          <TabsTrigger value="history" className="flex items-center gap-2">
            <History className="w-4 h-4" /> History
          </TabsTrigger>
        </TabsList>

        {/* SCANNER TAB */}
        <TabsContent value="scanner" className="space-y-4">
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
            {/* Scan Input Card */}
            <Card className="lg:col-span-2">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Target className="w-5 h-5 text-primary" />
                  Location Scanner
                </CardTitle>
                <CardDescription>
                  Scan any location on Earth for field resonance patterns
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Quick select known locations */}
                <div className="space-y-2">
                  <Label>Quick Select Location</Label>
                  <Select value={selectedLocation} onValueChange={handleLocationSelect}>
                    <SelectTrigger>
                      <SelectValue placeholder="Choose a known location..." />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="" disabled>Sacred Sites</SelectItem>
                      {KNOWN_LOCATIONS.filter(l => l.type === "sacred").map(loc => (
                        <SelectItem key={loc.name} value={loc.name}>
                          🏛️ {loc.name}
                        </SelectItem>
                      ))}
                      <Separator className="my-1" />
                      <SelectItem value="" disabled>Magnetic Anomalies</SelectItem>
                      {KNOWN_LOCATIONS.filter(l => l.type === "magnetic").map(loc => (
                        <SelectItem key={loc.name} value={loc.name}>
                          🧭 {loc.name}
                        </SelectItem>
                      ))}
                      <Separator className="my-1" />
                      <SelectItem value="" disabled>Water Networks</SelectItem>
                      {KNOWN_LOCATIONS.filter(l => l.type === "hydro").map(loc => (
                        <SelectItem key={loc.name} value={loc.name}>
                          💧 {loc.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                {/* Manual coordinate input */}
                <div className="grid grid-cols-3 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="latitude">Latitude</Label>
                    <Input
                      id="latitude"
                      type="number"
                      step="0.0001"
                      min="-90"
                      max="90"
                      value={latitude}
                      onChange={(e) => {
                        setLatitude(e.target.value);
                        setSelectedLocation("");
                      }}
                      placeholder="-90 to 90"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="longitude">Longitude</Label>
                    <Input
                      id="longitude"
                      type="number"
                      step="0.0001"
                      min="-180"
                      max="180"
                      value={longitude}
                      onChange={(e) => {
                        setLongitude(e.target.value);
                        setSelectedLocation("");
                      }}
                      placeholder="-180 to 180"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="altitude">Altitude (m)</Label>
                    <Input
                      id="altitude"
                      type="number"
                      step="1"
                      value={altitude}
                      onChange={(e) => setAltitude(e.target.value)}
                      placeholder="meters"
                    />
                  </div>
                </div>

                {/* Action buttons */}
                <div className="flex gap-2">
                  <Button
                    onClick={handleScan}
                    disabled={isScanPending}
                    className="flex-1"
                    size="lg"
                  >
                    {isScanPending ? (
                      <>
                        <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                        Scanning...
                      </>
                    ) : (
                      <>
                        <Scan className="w-5 h-5 mr-2" />
                        Run Field Scan
                      </>
                    )}
                  </Button>
                  <Button
                    variant="outline"
                    onClick={handleGetCurrentLocation}
                    title="Use current GPS location"
                  >
                    <MapPin className="w-5 h-5" />
                  </Button>
                </div>

                {/* Operational Mode */}
                <div className="pt-4 border-t">
                  <Label>Operational Mode</Label>
                  <div className="grid grid-cols-3 gap-2 mt-2">
                    <Button
                      variant={state?.operationalMode === "NoIoTPassive" ? "default" : "outline"}
                      size="sm"
                      onClick={() => setOperationalMode(0)}
                      className="flex flex-col items-center py-3 h-auto"
                    >
                      <Satellite className="w-5 h-5 mb-1" />
                      <span className="text-xs">Passive</span>
                      <span className="text-[10px] text-muted-foreground">Satellite Only</span>
                    </Button>
                    <Button
                      variant={state?.operationalMode === "EdgeIoT" ? "default" : "outline"}
                      size="sm"
                      onClick={() => setOperationalMode(1)}
                      className="flex flex-col items-center py-3 h-auto"
                    >
                      <Antenna className="w-5 h-5 mb-1" />
                      <span className="text-xs">Edge IoT</span>
                      <span className="text-[10px] text-muted-foreground">Local Sensors</span>
                    </Button>
                    <Button
                      variant={state?.operationalMode === "Hybrid" ? "default" : "outline"}
                      size="sm"
                      onClick={() => setOperationalMode(2)}
                      className="flex flex-col items-center py-3 h-auto"
                    >
                      <Radio className="w-5 h-5 mb-1" />
                      <span className="text-xs">Hybrid</span>
                      <span className="text-[10px] text-muted-foreground">Full Fusion</span>
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Scan Result Card */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Activity className="w-5 h-5 text-primary" />
                  Scan Result
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {lastScanResult ? (
                  <>
                    {/* Risk Level Badge */}
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-muted-foreground">Risk Level</span>
                      <Badge className={getRiskColor(lastScanResult.riskLevel)}>
                        {lastScanResult.riskLevel}
                      </Badge>
                    </div>

                    {/* Total Resonance */}
                    <div className="space-y-2">
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Total Resonance</span>
                        <span className="font-mono font-medium">
                          {(lastScanResult.totalResonance * 100).toFixed(2)}%
                        </span>
                      </div>
                      <Progress value={lastScanResult.totalResonance * 100} />
                    </div>

                    {/* Pattern Matches */}
                    <div className="grid grid-cols-2 gap-2">
                      <div className={`p-2 rounded-lg ${lastScanResult.isHotspot ? "bg-primary/20" : "bg-muted"}`}>
                        <p className="text-xs text-muted-foreground">Hotspot</p>
                        <p className="font-medium">{lastScanResult.isHotspot ? "✓ Yes" : "✗ No"}</p>
                      </div>
                      <div className={`p-2 rounded-lg ${lastScanResult.forwardPatternMatch ? "bg-green-500/20" : "bg-muted"}`}>
                        <p className="text-xs text-muted-foreground">Forward Pattern</p>
                        <p className="font-medium">{lastScanResult.forwardPatternMatch ? "✓ Match" : "✗ None"}</p>
                      </div>
                      <div className={`p-2 rounded-lg ${lastScanResult.inversePatternMatch ? "bg-orange-500/20" : "bg-muted"}`}>
                        <p className="text-xs text-muted-foreground">Inverse Pattern</p>
                        <p className="font-medium">{lastScanResult.inversePatternMatch ? "⚠ Detected" : "✓ Clear"}</p>
                      </div>
                      <div className={`p-2 rounded-lg ${lastScanResult.isOverlapHotspot ? "bg-red-500/20" : "bg-muted"}`}>
                        <p className="text-xs text-muted-foreground">Overlap Hotspot</p>
                        <p className="font-medium">{lastScanResult.isOverlapHotspot ? "⚠ Yes" : "✓ No"}</p>
                      </div>
                    </div>

                    {/* Magnetic Field */}
                    <Separator />
                    <div className="space-y-2">
                      <p className="text-sm font-medium flex items-center gap-2">
                        <Compass className="w-4 h-4" />
                        Magnetic Field
                      </p>
                      <div className="grid grid-cols-3 gap-2 text-xs">
                        <div className="p-2 bg-muted rounded">
                          <p className="text-muted-foreground">Intensity</p>
                          <p className="font-mono">{lastScanResult.magneticField.intensity.toFixed(0)} nT</p>
                        </div>
                        <div className="p-2 bg-muted rounded">
                          <p className="text-muted-foreground">Declination</p>
                          <p className="font-mono">{lastScanResult.magneticField.declination.toFixed(2)}°</p>
                        </div>
                        <div className="p-2 bg-muted rounded">
                          <p className="text-muted-foreground">Inclination</p>
                          <p className="font-mono">{lastScanResult.magneticField.inclination.toFixed(2)}°</p>
                        </div>
                      </div>
                    </div>
                  </>
                ) : (
                  <div className="text-center py-8 text-muted-foreground">
                    <Globe className="w-12 h-12 mx-auto mb-3 opacity-30" />
                    <p>No scan results yet</p>
                    <p className="text-xs mt-1">Enter coordinates and click "Run Field Scan"</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Risk Summary Card */}
          {riskSummary && (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Shield className="w-5 h-5 text-primary" />
                  Risk Assessment Summary
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Drift Risk</p>
                    <Badge className={getRiskColor(riskSummary.driftRiskLevel)}>
                      {riskSummary.driftRiskLevel}
                    </Badge>
                  </div>
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Interference Risk</p>
                    <p className="text-lg font-mono font-medium">{(riskSummary.interferenceRisk * 100).toFixed(1)}%</p>
                  </div>
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Jamming Likelihood</p>
                    <p className="text-lg font-mono font-medium">{(riskSummary.jammingLikelihood * 100).toFixed(1)}%</p>
                  </div>
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Infrastructure Stress</p>
                    <p className="text-lg font-mono font-medium">{(riskSummary.infrastructureStress * 100).toFixed(1)}%</p>
                  </div>
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Anomaly Score</p>
                    <p className="text-lg font-mono font-medium">{(riskSummary.anomalyScore * 100).toFixed(1)}%</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        {/* LAYERS TAB */}
        <TabsContent value="layers" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Layers className="w-5 h-5 text-primary" />
                Seven Stacking Layers
              </CardTitle>
              <CardDescription>
                φ-weighted resonance scores across all detection layers
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {layerScores ? (
                <>
                  <LayerScoreBar
                    label="Geomagnetic (IGRF Model)"
                    value={layerScores.geomagnetic}
                    icon={<Compass className="w-4 h-4" />}
                    color="bg-blue-500"
                  />
                  <LayerScoreBar
                    label="Sacred Site Geometry"
                    value={layerScores.sacredSite}
                    icon={<Mountain className="w-4 h-4" />}
                    color="bg-purple-500"
                  />
                  <LayerScoreBar
                    label="Hydro-Karst Networks"
                    value={layerScores.hydroKarst}
                    icon={<Droplets className="w-4 h-4" />}
                    color="bg-cyan-500"
                  />
                  <LayerScoreBar
                    label="Astro-Calendar Alignments"
                    value={layerScores.astroCalendar}
                    icon={<Sun className="w-4 h-4" />}
                    color="bg-yellow-500"
                  />
                  <LayerScoreBar
                    label="Collapse/Conflict Periods"
                    value={layerScores.collapseConflict}
                    icon={<AlertTriangle className="w-4 h-4" />}
                    color="bg-orange-500"
                  />
                  <LayerScoreBar
                    label="Canon/Legal Recoding"
                    value={layerScores.canonLegal}
                    icon={<Scale className="w-4 h-4" />}
                    color="bg-green-500"
                  />
                  <LayerScoreBar
                    label="Inverse Signatures"
                    value={layerScores.inverseSignature}
                    icon={<Eye className="w-4 h-4" />}
                    color="bg-red-500"
                  />

                  <Separator />

                  <div className="flex items-center justify-between p-3 bg-primary/10 rounded-lg">
                    <span className="font-medium">Total Weighted Resonance</span>
                    <span className="text-2xl font-mono font-bold text-primary">
                      {(layerScores.totalWeightedResonance * 100).toFixed(2)}%
                    </span>
                  </div>
                </>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  <Layers className="w-12 h-12 mx-auto mb-3 opacity-30" />
                  <p>Loading layer scores...</p>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* CALENDARS TAB */}
        <TabsContent value="calendars" className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* Four Calendar Systems */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Calendar className="w-5 h-5 text-primary" />
                  Four Calendar Systems
                </CardTitle>
                <CardDescription>
                  Simultaneous time indexing across all rhythms
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-3">
                {calendarState ? (
                  <>
                    <CalendarDisplay
                      label="Solar Calendar"
                      value={`Day ${calendarState.solarDayOfYear} of ${calendarState.solarYear}`}
                      icon={<Sun className="w-5 h-5 text-yellow-500" />}
                      sublabel="Infrastructure & Environment Rhythms"
                    />
                    <CalendarDisplay
                      label="Lunar Calendar"
                      value={`Phase ${(calendarState.lunarPhase * 100).toFixed(0)}% • Day ${calendarState.lunarDaySinceNew.toFixed(1)}`}
                      icon={<Moon className="w-5 h-5 text-slate-400" />}
                      sublabel="Biological & Water-Linked Rhythms"
                    />
                    <CalendarDisplay
                      label="Sidereal Calendar"
                      value={`${calendarState.zodiacAge} Age`}
                      icon={<Zap className="w-5 h-5 text-purple-500" />}
                      sublabel={`Precession: ${calendarState.siderealPrecessionAngle.toFixed(2)}°`}
                    />
                    <CalendarDisplay
                      label="Operational Calendar"
                      value={`Cycle ${calendarState.operationalCycle} • Day ${calendarState.missionDayInCycle}`}
                      icon={<Signal className="w-5 h-5 text-green-500" />}
                      sublabel={`Shift Phase: ${(calendarState.operationalShiftPhase * 100).toFixed(0)}%`}
                    />
                  </>
                ) : (
                  <div className="text-center py-8 text-muted-foreground">
                    <Calendar className="w-12 h-12 mx-auto mb-3 opacity-30" />
                    <p>Loading calendar state...</p>
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Mayan Calendar */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Waves className="w-5 h-5 text-primary" />
                  Mayan Calendar System
                </CardTitle>
                <CardDescription>
                  Ancient memory encoding — Tzolkin, Haab, Long Count
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-3">
                {calendarState ? (
                  <>
                    <CalendarDisplay
                      label="Tzolkin (Sacred 260)"
                      value={`${calendarState.mayanTzolkinTrecena}.${calendarState.mayanTzolkinDay}`}
                      icon={<Database className="w-5 h-5 text-amber-500" />}
                      sublabel={`Day ${calendarState.mayanTzolkinDay} • Trecena ${calendarState.mayanTzolkinTrecena}`}
                    />
                    <CalendarDisplay
                      label="Haab (Civil 365)"
                      value={`${calendarState.mayanHaabDay}.${calendarState.mayanHaabMonth}`}
                      icon={<Globe className="w-5 h-5 text-emerald-500" />}
                      sublabel={`Day ${calendarState.mayanHaabDay} of Month ${calendarState.mayanHaabMonth}`}
                    />
                    <div className="p-4 bg-gradient-to-r from-amber-500/10 to-emerald-500/10 rounded-lg">
                      <p className="text-xs text-muted-foreground mb-1">Calendar Round Position</p>
                      <p className="text-lg font-mono font-medium">
                        {calendarState.mayanTzolkinTrecena}.{calendarState.mayanTzolkinDay} • {calendarState.mayanHaabDay}.{calendarState.mayanHaabMonth}
                      </p>
                      <p className="text-xs text-muted-foreground mt-1">
                        52-year cycle synchronization point
                      </p>
                    </div>
                  </>
                ) : (
                  <div className="text-center py-8 text-muted-foreground">
                    <Waves className="w-12 h-12 mx-auto mb-3 opacity-30" />
                    <p>Loading Mayan calendar...</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* HISTORY TAB */}
        <TabsContent value="history" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <History className="w-5 h-5 text-primary" />
                Scan History
              </CardTitle>
              <CardDescription>
                Last 10 scans • Memory indexed by location, phase, and field state
              </CardDescription>
            </CardHeader>
            <CardContent>
              {scanHistory.length > 0 ? (
                <ScrollArea className="h-[400px]">
                  <div className="space-y-3">
                    {scanHistory.map((scan, index) => (
                      <div
                        key={index}
                        className="p-3 border rounded-lg hover:bg-muted/50 transition-colors"
                      >
                        <div className="flex items-center justify-between mb-2">
                          <div className="flex items-center gap-2">
                            <MapPin className="w-4 h-4 text-muted-foreground" />
                            <span className="font-mono text-sm">
                              {scan.latitude.toFixed(4)}°, {scan.longitude.toFixed(4)}°
                            </span>
                          </div>
                          <Badge className={getRiskColor(scan.riskLevel)} variant="outline">
                            {scan.riskLevel}
                          </Badge>
                        </div>
                        <div className="grid grid-cols-4 gap-2 text-xs">
                          <div>
                            <span className="text-muted-foreground">Resonance:</span>
                            <span className="ml-1 font-mono">{(scan.totalResonance * 100).toFixed(1)}%</span>
                          </div>
                          <div>
                            <span className="text-muted-foreground">Hotspot:</span>
                            <span className="ml-1">{scan.isHotspot ? "✓" : "✗"}</span>
                          </div>
                          <div>
                            <span className="text-muted-foreground">Forward:</span>
                            <span className="ml-1">{scan.forwardPatternMatch ? "✓" : "✗"}</span>
                          </div>
                          <div>
                            <span className="text-muted-foreground">Inverse:</span>
                            <span className="ml-1">{scan.inversePatternMatch ? "⚠" : "✓"}</span>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              ) : (
                <div className="text-center py-12 text-muted-foreground">
                  <History className="w-12 h-12 mx-auto mb-3 opacity-30" />
                  <p>No scan history yet</p>
                  <p className="text-xs mt-1">Run scans to build memory index</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Memory Statistics */}
          {state && (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Database className="w-5 h-5 text-primary" />
                  Memory Index Statistics
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Total Memory Points</p>
                    <p className="text-2xl font-mono font-bold">{state.memoryIndexCount}</p>
                  </div>
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Hotspots Detected</p>
                    <p className="text-2xl font-mono font-bold">{state.hotspotCount}</p>
                  </div>
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Forward Patterns</p>
                    <p className="text-2xl font-mono font-bold">{state.forwardPatternsFound}</p>
                  </div>
                  <div className="p-3 bg-muted/50 rounded-lg">
                    <p className="text-xs text-muted-foreground">Inverse Patterns</p>
                    <p className="text-2xl font-mono font-bold">{state.inversePatternsFound}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Organism Memory Integration */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Activity className="w-5 h-5 text-primary" />
                Organism Memory Integration
              </CardTitle>
              <CardDescription>
                Live connection to resonance memory substrate • Council Zone alignment
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {organismState ? (
                  <>
                    <div className="p-3 bg-primary/10 rounded-lg">
                      <p className="text-xs text-muted-foreground">Kuramoto R (Coherence)</p>
                      <p className="text-2xl font-mono font-bold">{(organismState.kuramotoR * 100).toFixed(1)}%</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        {organismState.kuramotoR >= 0.618 ? "✓ Phase-locked" : "○ Seeking lock"}
                      </p>
                    </div>
                    <div className="p-3 bg-green-500/10 rounded-lg">
                      <p className="text-xs text-muted-foreground">Law Engine Score</p>
                      <p className="text-2xl font-mono font-bold">{(organismState.lawEngineScore * 100).toFixed(0)}%</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        {organismState.isDoctrineIntact ? "✓ Doctrine intact" : "⚠ Drift detected"}
                      </p>
                    </div>
                    <div className="p-3 bg-yellow-500/10 rounded-lg">
                      <p className="text-xs text-muted-foreground">OMNIS Status</p>
                      <p className="text-2xl font-mono font-bold">{organismState.omnisActive ? "ACTIVE" : "DORMANT"}</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Charge: {(organismState.omnisCharge * 100).toFixed(0)}%
                      </p>
                    </div>
                    <div className="p-3 bg-purple-500/10 rounded-lg">
                      <p className="text-xs text-muted-foreground">Heritage Avg</p>
                      <p className="text-2xl font-mono font-bold">{(organismState.heritageAvg * 100).toFixed(1)}%</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Beat #{organismState.systemHeartbeat}
                      </p>
                    </div>
                  </>
                ) : (
                  <>
                    <div className="p-3 bg-muted/50 rounded-lg">
                      <p className="text-xs text-muted-foreground">Kuramoto R</p>
                      <p className="text-lg font-mono text-muted-foreground">—</p>
                    </div>
                    <div className="p-3 bg-muted/50 rounded-lg">
                      <p className="text-xs text-muted-foreground">Law Engine</p>
                      <p className="text-lg font-mono text-muted-foreground">—</p>
                    </div>
                    <div className="p-3 bg-muted/50 rounded-lg">
                      <p className="text-xs text-muted-foreground">OMNIS</p>
                      <p className="text-lg font-mono text-muted-foreground">—</p>
                    </div>
                    <div className="p-3 bg-muted/50 rounded-lg">
                      <p className="text-xs text-muted-foreground">Heritage</p>
                      <p className="text-lg font-mono text-muted-foreground">—</p>
                    </div>
                  </>
                )}
              </div>

              {/* Memory Index Key explanation */}
              <Separator className="my-4" />
              <div className="p-4 bg-muted/30 rounded-lg">
                <p className="text-xs font-medium mb-2 flex items-center gap-2">
                  <Database className="w-4 h-4" />
                  Memory Index Key Formula
                </p>
                <p className="font-mono text-sm text-primary">
                  M = f(event, phase, location, field-state, doctrine-score)
                </p>
                <p className="text-xs text-muted-foreground mt-2">
                  Every scan is indexed by 5 dimensions: event signature, calendar phase, 
                  geo-coordinate, magnetic field state, and doctrine resonance score.
                  This enables cross-generational memory continuity through geographic anchoring.
                </p>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}

export default GeoResonanceScanner;
