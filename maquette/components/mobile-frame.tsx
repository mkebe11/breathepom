import type { ReactNode } from "react"

interface MobileFrameProps {
  children: ReactNode
  title: string
}

export function MobileFrame({ children, title }: MobileFrameProps) {
  return (
    <div className="flex flex-col">
      <div className="mb-3 text-center">
        <h2 className="text-sm font-medium text-muted-foreground">{title}</h2>
      </div>
      <div className="relative mx-auto w-full max-w-[375px]">
        {/* Phone frame */}
        <div className="relative overflow-hidden rounded-[3rem] border-[14px] border-foreground/90 bg-foreground/90 shadow-2xl">
          {/* Notch */}
          <div className="absolute left-1/2 top-0 z-10 h-7 w-40 -translate-x-1/2 rounded-b-3xl bg-foreground/90" />

          {/* Screen */}
          <div className="relative aspect-[9/19.5] overflow-hidden bg-background">
            {/* Status bar */}
            <div className="absolute left-0 right-0 top-0 z-10 flex items-center justify-between px-8 pt-3 text-xs text-foreground">
              <span className="font-medium">9:41</span>
              <div className="flex items-center gap-1">
                <div className="h-3 w-4 rounded-sm border border-foreground">
                  <div className="h-full w-3/4 bg-foreground" />
                </div>
              </div>
            </div>

            {/* Content */}
            <div className="h-full overflow-y-auto pt-12">{children}</div>
          </div>
        </div>
      </div>
    </div>
  )
}
