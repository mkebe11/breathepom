"use client"
import { Card } from "@/components/ui/card"
import { Timer, Wind, TrendingUp, Settings } from "lucide-react"

export function HomeScreen() {
  return (
    <div className="flex h-full flex-col p-6">
      {/* Header */}
      <div className="mb-8">
        <h1 className="mb-2 text-balance text-3xl font-bold text-foreground">Bonjour</h1>
        <p className="text-pretty text-sm text-muted-foreground">Prêt à améliorer votre concentration ?</p>
      </div>

      {/* Quick stats */}
      <Card className="mb-6 bg-gradient-to-br from-primary to-accent p-6 text-primary-foreground">
        <div className="mb-2 text-sm font-medium opacity-90">Aujourd'hui</div>
        <div className="mb-1 text-4xl font-bold">4</div>
        <div className="text-sm opacity-90">Sessions complétées</div>
      </Card>

      {/* Main actions */}
      <div className="mb-6 grid gap-4">
        <Card className="group cursor-pointer overflow-hidden transition-all hover:shadow-lg">
          <div className="flex items-center gap-4 p-5">
            <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/10">
              <Timer className="h-7 w-7 text-primary" />
            </div>
            <div className="flex-1">
              <h3 className="mb-1 font-semibold text-card-foreground">Pomodoro</h3>
              <p className="text-xs text-muted-foreground">Session de 25 minutes</p>
            </div>
          </div>
        </Card>

        <Card className="group cursor-pointer overflow-hidden transition-all hover:shadow-lg">
          <div className="flex items-center gap-4 p-5">
            <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-accent/10">
              <Wind className="h-7 w-7 text-accent" />
            </div>
            <div className="flex-1">
              <h3 className="mb-1 font-semibold text-card-foreground">Respiration</h3>
              <p className="text-xs text-muted-foreground">Exercices guidés</p>
            </div>
          </div>
        </Card>
      </div>

      {/* Bottom navigation */}
      <div className="mt-auto">
        <div className="flex items-center justify-around rounded-3xl bg-card p-4 shadow-lg">
          <button className="flex flex-col items-center gap-1">
            <Timer className="h-6 w-6 text-primary" />
            <span className="text-xs font-medium text-primary">Timer</span>
          </button>
          <button className="flex flex-col items-center gap-1">
            <Wind className="h-6 w-6 text-muted-foreground" />
            <span className="text-xs text-muted-foreground">Respirer</span>
          </button>
          <button className="flex flex-col items-center gap-1">
            <TrendingUp className="h-6 w-6 text-muted-foreground" />
            <span className="text-xs text-muted-foreground">Stats</span>
          </button>
          <button className="flex flex-col items-center gap-1">
            <Settings className="h-6 w-6 text-muted-foreground" />
            <span className="text-xs text-muted-foreground">Réglages</span>
          </button>
        </div>
      </div>
    </div>
  )
}
