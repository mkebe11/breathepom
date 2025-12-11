"use client"

import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Wind, Play } from "lucide-react"

const breathingExercises = [
  {
    name: "4-7-8",
    description: "Calme et relaxation",
    duration: "5 min",
    color: "from-primary to-accent",
  },
  {
    name: "Box Breathing",
    description: "Concentration et équilibre",
    duration: "4 min",
    color: "from-accent to-chart-2",
  },
  {
    name: "Cohérence cardiaque",
    description: "Réduction du stress",
    duration: "5 min",
    color: "from-chart-3 to-primary",
  },
]

export function BreathingScreen() {
  return (
    <div className="flex h-full flex-col p-6">
      {/* Header */}
      <div className="mb-8">
        <h1 className="mb-2 text-balance text-3xl font-bold text-foreground">Respiration</h1>
        <p className="text-pretty text-sm text-muted-foreground">Choisissez un exercice guidé</p>
      </div>

      {/* Active breathing animation */}
      <Card className="mb-8 overflow-hidden bg-gradient-to-br from-primary/10 via-accent/10 to-chart-2/10 p-8">
        <div className="flex flex-col items-center">
          <div className="relative mb-6 flex h-32 w-32 items-center justify-center">
            {/* Animated breathing circle */}
            <div className="absolute h-24 w-24 animate-pulse rounded-full bg-gradient-to-br from-primary to-accent opacity-30" />
            <div className="absolute h-16 w-16 animate-pulse rounded-full bg-gradient-to-br from-primary to-accent opacity-50 [animation-delay:0.5s]" />
            <Wind className="relative h-12 w-12 text-primary" />
          </div>
          <div className="mb-2 text-center text-sm font-medium text-muted-foreground">Prêt à commencer</div>
          <Button className="bg-gradient-to-r from-primary to-accent">
            <Play className="mr-2 h-4 w-4 fill-current" />
            Démarrer
          </Button>
        </div>
      </Card>

      {/* Exercise list */}
      <div className="space-y-4">
        <h2 className="text-sm font-semibold text-foreground">Exercices disponibles</h2>
        {breathingExercises.map((exercise, index) => (
          <Card key={index} className="group cursor-pointer overflow-hidden transition-all hover:shadow-lg">
            <div className="flex items-center gap-4 p-4">
              <div
                className={`flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br ${exercise.color}`}
              >
                <Wind className="h-6 w-6 text-white" />
              </div>
              <div className="flex-1">
                <h3 className="mb-1 font-semibold text-card-foreground">{exercise.name}</h3>
                <p className="text-xs text-muted-foreground">{exercise.description}</p>
              </div>
              <div className="text-xs font-medium text-muted-foreground">{exercise.duration}</div>
            </div>
          </Card>
        ))}
      </div>
    </div>
  )
}
