"use client"

import { MdLogout } from "react-icons/md"
import { getToken, removeToken } from "@/app/_actions/auth"
import { getAdminBaseUrl } from "@/app/_utils/constants"
import { useRouter } from "next/navigation"

function LogoutButton() {
  const router = useRouter()

  const onLogout = async () => {
    const endpoint = `${getAdminBaseUrl()}/logout`
    const token = await getToken()
    fetch(endpoint, {
      headers: {"Authorization": `Bearer ${token}`},
      method: "delete",
    })
    await removeToken()
    router.push("/login")
  }
  
  return (
    <button
      className="
        text-white/50 hover:bg-white/10 hover:text-white
        w-full flex items-center duration-100 px-2 py-4 text-lg
        mt-auto
      "
      onClick={onLogout}
    >
      <span className="text-2xl px-4"><MdLogout /></span>
      Logout
    </button>
  )
}

export default LogoutButton