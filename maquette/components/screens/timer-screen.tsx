"use client"

import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Play, RotateCcw, Coffee } from "lucide-react"

export function TimerScreen() {
  return (
    <div className="flex h-full flex-col p-6">
      {/* Mode selector */}
      <div className="mb-8 flex gap-2 rounded-2xl bg-muted p-1">
        <button className="flex-1 rounded-xl bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-all">
          Focus
        </button>
        <button className="flex-1 rounded-xl px-4 py-2 text-sm font-medium text-muted-foreground transition-all hover:bg-background">
          Pause
        </button>
        <button className="flex-1 rounded-xl px-4 py-2 text-sm font-medium text-muted-foreground transition-all hover:bg-background">
          Longue
        </button>
      </div>

      {/* Timer circle */}
      <div className="mb-8 flex flex-1 items-center justify-center">
        <div className="relative">
          {/* Outer circle with gradient */}
          <svg className="h-64 w-64 -rotate-90 transform">
            <circle
              cx="128"
              cy="128"
              r="112"
              stroke="currentColor"
              strokeWidth="8"
              fill="none"
              className="text-muted"
            />
            <circle
              cx="128"
              cy="128"
              r="112"
              stroke="url(#gradient)"
              strokeWidth="8"
              fill="none"
              strokeDasharray="703.72"
              strokeDashoffset="176"
              strokeLinecap="round"
              className="transition-all duration-1000"
            />
            <defs>
              <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" className="text-primary" stopColor="currentColor" />
                <stop offset="100%" className="text-accent" stopColor="currentColor" />
              </linearGradient>
            </defs>
          </svg>

          {/* Timer display */}
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <div className="mb-2 text-6xl font-bold tabular-nums text-foreground">25:00</div>
            <div className="text-sm text-muted-foreground">Session 1 sur 4</div>
          </div>
        </div>
      </div>

      {/* Controls */}
      <div className="mb-6 flex items-center justify-center gap-4">
        <Button size="icon" variant="outline" className="h-14 w-14 rounded-full bg-transparent">
          <RotateCcw className="h-5 w-5" />
        </Button>

        <Button size="icon" className="h-20 w-20 rounded-full bg-gradient-to-br from-primary to-accent shadow-lg">
          <Play className="h-8 w-8 fill-current" />
        </Button>

        <Button size="icon" variant="outline" className="h-14 w-14 rounded-full bg-transparent">
          <Coffee className="h-5 w-5" />
        </Button>
      </div>

      {/* Task info */}
      <Card className="p-4">
        <div className="mb-2 text-xs font-medium text-muted-foreground">TÂCHE ACTUELLE</div>
        <div className="text-sm font-medium text-card-foreground">Travail concentré</div>
      </Card>
    </div>
  )
}
