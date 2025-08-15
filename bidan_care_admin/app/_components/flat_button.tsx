import { MouseEventHandler, ReactNode } from "react"

interface FlatButtonProps {
  className?: string
  onClick?: MouseEventHandler<HTMLButtonElement>
  type?: "button" | "reset" | "submit",
  children: ReactNode
  disabled?: boolean
}
function FlatButton({ className, onClick, type, children, disabled }: FlatButtonProps) {
  return (
    <button
      className={`
        border border-accent bg-white text-accent text-sm py-2 px-8 ${className}
        hover:bg-accent hover:text-white duration-200
      `}
      onClick={onClick}
      type={type}
      disabled={disabled}
    >
      {children}
    </button>
  )
}

export default FlatButton