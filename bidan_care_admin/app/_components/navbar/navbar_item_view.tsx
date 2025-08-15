"use client"

import { NavbarItem } from "@/app/_data/navbars"
import Link from "next/link"
import { usePathname } from "next/navigation"

interface NavbarItemProps {
  navbar: NavbarItem
  className?: string
}
function NavbarItemView({ navbar, className }: NavbarItemProps) {
  const pathname = usePathname()
  const isSelected = navbar.href === pathname
  const twSelected = "bg-black/30 text-white"
  const twUnselected = "text-white/50 hover:bg-white/10 hover:text-white"

  return (
    <Link
      href={navbar.href}
      className={`
        w-full flex items-center duration-100 px-2 py-4 text-lg
        ${isSelected ? twSelected : twUnselected}
        ${className}
    `}>
      <span className="text-2xl px-4">{navbar.icon}</span>
      {navbar.label}
    </Link>
  )
}

export default NavbarItemView