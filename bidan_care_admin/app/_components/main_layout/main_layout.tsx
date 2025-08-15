import { ReactNode, Suspense } from "react"
import Navbar from "../navbar/navbar"
import LayoutLoading from "./layout_loading"

interface MainLayoutProps {
  title: string
  children?: ReactNode
}
function MainLayout({ title, children }: MainLayoutProps) {
  return (
    <main className="flex">
      <Navbar />
      <Suspense fallback={<LayoutLoading />}>
        <div className="p-8 flex-1">
          <h1 className="
            px-6 py-4 border-l-8 border-l-primary bg-white text-2xl
            shadow-lg
          ">{title}</h1>
          <div className="py-8">
            {children}
          </div>
        </div>
      </Suspense>
    </main>
  )
}

export default MainLayout