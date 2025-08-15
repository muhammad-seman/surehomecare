import Link from "next/link"
import { ReactNode } from "react"

interface ElevatedLinkButtonProps {
  className?: string
  href: string
  type?: "button" | "reset" | "submit",
  children: ReactNode
}
function ElevatedLinkButton({ className, href, children, type }: ElevatedLinkButtonProps) {
  return (
    <Link
      className={`relative bg-accent py-2 px-8 text-white text-sm ${className}`}
      type={type}
      href={href}
    >
      <div className="
        absolute w-full h-full top-0 left-0 duration-200
        hover:bg-white/20 hover:shadow-lg
      ">
      </div>
      {children}
    </Link>
  )
}

export default ElevatedLinkButton