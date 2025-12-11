import { MobileFrame } from "@/components/mobile-frame"
import { HomeScreen } from "@/components/screens/home-screen"
import { TimerScreen } from "@/components/screens/timer-screen"
import { BreathingScreen } from "@/components/screens/breathing-screen"
import { StatsScreen } from "@/components/screens/stats-screen"

export default function Page() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-background via-secondary/20 to-accent/10 p-4 md:p-8">
      <div className="mx-auto max-w-7xl">
        <div className="mb-8 text-center">
          <h1 className="mb-2 text-balance text-4xl font-bold tracking-tight text-foreground md:text-5xl">
            FocusBreath
          </h1>
          <p className="text-pretty text-lg text-muted-foreground">
            Maquette d'application mobile - Pomodoro + Respiration guidée
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          <MobileFrame title="Accueil">
            <HomeScreen />
          </MobileFrame>

          <MobileFrame title="Minuteur Pomodoro">
            <TimerScreen />
          </MobileFrame>

          <MobileFrame title="Respiration guidée">
            <BreathingScreen />
          </MobileFrame>

          <MobileFrame title="Statistiques">
            <StatsScreen />
          </MobileFrame>
        </div>
      </div>
    </main>
  )
}
