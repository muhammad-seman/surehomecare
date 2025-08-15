import type { Metadata } from "next"
import "./globals.css"
import { webName } from "./_utils/constants"

export const metadata: Metadata = {
  title: webName,
  description: "For a caring mother",
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <body className="font-lato bg-background text-textPrimary">
        {children}
      </body>
    </html>
  )
}
