"use client"

import { BarLoader } from "react-spinners"
import { themeColors } from "../_utils/constants"

function Loading() {
  return (
    <main className="h-screen flex bg-gray-300">
      <div className="
        rounded-lg bg-white justify-center items-center m-auto shadow-lg
        shadow-black/20 w-48 h-32 flex flex-col
      ">
        <BarLoader color={themeColors.primary} />
        <p className="pt-5">Memuat...</p>
      </div>
    </main>
  )
}

export default Loading