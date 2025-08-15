import { MdHome, MdReceipt, MdHistory, MdPersonAdd, MdPerson } from "react-icons/md"
import { ReactElement } from "react"

export interface NavbarItem {
  href: string
  label: string
  icon: ReactElement
}

export const adminNavbars: NavbarItem[] = [
  {
    label: "Dashboard",
    href: "/",
    icon: <MdHome />,
  },
  {
    label: "Transaksi",
    href: "/transaksi",
    icon: <MdReceipt />,
  },
  {
    label: "Pengajuan Bidan",
    href: "/request_bidan",
    icon: <MdPersonAdd />
  },
  {
    label: "Bidan Terdaftar",
    href: "/daftar_bidan",
    icon: <MdPerson />
  },
  {
    label: "User Terdaftar",
    href: "/daftar_user",
    icon: <MdPerson />
  },
]

export const bidanNavbars: NavbarItem[] = [
  {
    label: "Dashboard",
    href: "/",
    icon: <MdHome />,
  },
  {
    label: "Riwayat Pelayanan",
    href: "/riwayat_pelayanan",
    icon: <MdHistory />,
  },
]