import { themeColors } from "@/app/_utils/constants"
import { BarLoader } from "react-spinners"

function LayoutLoading() {
  return (
    <div className="flex flex-1">
      <div className="
        rounded-lg bg-white justify-center items-center m-auto shadow-lg
        shadow-black/20 w-48 h-32 flex flex-col
      ">
        <BarLoader color={themeColors.primary} />
        <p className="pt-5">Memuat...</p>
      </div>
    </div>
  )
}

export default LayoutLoading