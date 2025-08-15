"use client"

import { terimaRequest, tolakRequest } from "@/app/_actions/request_bidan"
import ElevatedButton from "@/app/_components/elevated_button"
import FlatButton from "@/app/_components/flat_button"
import { themeColors } from "@/app/_utils/constants"
import { useRouter } from "next/navigation"
import { useState } from "react"
import Swal from "sweetalert2"

interface DetailActionsProps {
  id: string
}
function DetailActions({ id }: DetailActionsProps) {
  const router = useRouter()
  const [isLoading, setLoading] = useState(false)

  const onReply = async (terima: boolean) => {
    setLoading(true)
    const success = terima ? await terimaRequest(id) : await tolakRequest(id)
    setLoading(false)
    if (success) {
      await Swal.fire({
        text: `Berhasil ${terima ? "terima" : "menolak"} pengajuan`,
        icon: "success",
        confirmButtonColor: themeColors.primary
      })
      router.push("/request_bidan")
    }
  }
  
  const onTolak = () => onReply(false)

  const onTerima = () => onReply(true)
  
  return (
    <div className="pt-12 flex justify-end">
      <FlatButton
        className="border-red-500 text-red-500 hover:bg-red-500"
        onClick={onTolak} disabled={isLoading}
      >
        Tolak
      </FlatButton>
      <ElevatedButton
        className="ml-2 bg-primary"
        onClick={onTerima} disabled={isLoading}
      >
        Terima
      </ElevatedButton>
    </div>
  )
}

export default DetailActions