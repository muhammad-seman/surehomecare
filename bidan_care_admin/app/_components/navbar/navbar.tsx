import { webName } from "../../_utils/constants"
import { adminNavbars, bidanNavbars } from "../../_data/navbars"
import NavbarItemView from "./navbar_item_view"
import LogoutButton from "./logout_button"
import { cookies } from "next/headers"
import { v4 } from "uuid"

async function Navbar() {
  const cookieStore = await cookies()
  const role = cookieStore.get("ROLE")
  const isBidan = (role?.value ?? "bidan") === "bidan"
  const navbars = isBidan ? bidanNavbars : adminNavbars
  
  return (
    <div className="
      sticky left-0 top-0 h-screen w-64
      bg-primary text-white flex flex-col
    ">
      <h1 className="text-3xl text-center font-bold py-8">{webName}</h1>
      <div className="flex flex-col py-12">
        {navbars.map((navbar) => {
          const key = v4()
          return <NavbarItemView key={key} navbar={navbar} />
        })}
      </div>

      <LogoutButton />
    </div>
  )
}

export default Navbar