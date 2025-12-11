"use client"

import { Card } from "@/components/ui/card"
import { TrendingUp, Timer, Wind, Target } from "lucide-react"

const stats = [
  {
    label: "Sessions cette semaine",
    value: "24",
    change: "+12%",
    icon: Timer,
    color: "text-primary",
  },
  {
    label: "Temps de focus total",
    value: "10h",
    change: "+8%",
    icon: Target,
    color: "text-accent",
  },
  {
    label: "Exercices de respiration",
    value: "18",
    change: "+25%",
    icon: Wind,
    color: "text-chart-2",
  },
]

const weeklyData = [
  { day: "L", sessions: 3 },
  { day: "M", sessions: 4 },
  { day: "M", sessions: 2 },
  { day: "J", sessions: 5 },
  { day: "V", sessions: 4 },
  { day: "S", sessions: 3 },
  { day: "D", sessions: 3 },
]

export function StatsScreen() {
  const maxSessions = Math.max(...weeklyData.map((d) => d.sessions))

  return (
    <div className="flex h-full flex-col p-6">
      {/* Header */}
      <div className="mb-8">
        <h1 className="mb-2 text-balance text-3xl font-bold text-foreground">Statistiques</h1>
        <p className="text-pretty text-sm text-muted-foreground">Votre progression cette semaine</p>
      </div>

      {/* Stats cards */}
      <div className="mb-8 space-y-3">
        {stats.map((stat, index) => {
          const Icon = stat.icon
          return (
            <Card key={index} className="p-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className={`rounded-xl bg-muted p-2 ${stat.color}`}>
                    <Icon className="h-5 w-5" />
                  </div>
                  <div>
                    <div className="text-xs text-muted-foreground">{stat.label}</div>
                    <div className="text-2xl font-bold text-card-foreground">{stat.value}</div>
                  </div>
                </div>
                <div className="flex items-center gap-1 text-xs font-medium text-accent">
                  <TrendingUp className="h-3 w-3" />
                  {stat.change}
                </div>
              </div>
            </Card>
          )
        })}
      </div>

      {/* Weekly chart */}
      <Card className="p-6">
        <h2 className="mb-6 text-sm font-semibold text-card-foreground">Sessions par jour</h2>
        <div className="flex items-end justify-between gap-2">
          {weeklyData.map((data, index) => (
            <div key={index} className="flex flex-1 flex-col items-center gap-2">
              <div className="relative w-full">
                <div
                  className="w-full rounded-lg bg-gradient-to-t from-primary to-accent transition-all"
                  style={{
                    height: `${(data.sessions / maxSessions) * 80}px`,
                    minHeight: "20px",
                  }}
                />
              </div>
              <div className="text-xs font-medium text-muted-foreground">{data.day}</div>
            </div>
          ))}
        </div>
      </Card>

      {/* Achievement */}
      <Card className="mt-6 bg-gradient-to-br from-primary/10 to-accent/10 p-4">
        <div className="flex items-center gap-3">
          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-gradient-to-br from-primary to-accent text-2xl">
            🎯
          </div>
          <div>
            <div className="mb-1 text-sm font-semibold text-card-foreground">Objectif hebdomadaire atteint !</div>
            <div className="text-xs text-muted-foreground">Continuez comme ça</div>
          </div>
        </div>
      </Card>
    </div>
  )
}
