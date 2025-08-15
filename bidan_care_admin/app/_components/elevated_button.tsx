import { MouseEventHandler, ReactNode } from "react"

interface ElevatedButtonProps {
  className?: string
  onClick?: MouseEventHandler<HTMLButtonElement>
  type?: "button" | "reset" | "submit",
  children: ReactNode
  disabled?: boolean
}
function ElevatedButton({ className, onClick, children, type, disabled = false }: ElevatedButtonProps) {
  return (
    <button
      className={`relative bg-accent py-2 px-8 text-white text-sm ${className}`}
      onClick={onClick}
      type={type}
      disabled={disabled}
      >
      <div className={`
        absolute w-full h-full top-0 left-0 duration-200
        ${disabled ? "bg-white/50" : "hover:bg-white/20 hover:shadow-lg"}
      `}>
      </div>
      {children}
    </button>
  )
}

export default ElevatedButton