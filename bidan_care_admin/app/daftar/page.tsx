import Link from "next/link"
import DaftarForm, { Kecamatan, Provinsi } from "./daftar_form"
import { webName } from "../_utils/constants"

async function DaftarPage() {
  const baseUrl = process.env.NEXT_PUBLIC_BACKEND_BASE_URL
  const listProvinsi = await getProvinsi(baseUrl)
  const listKecamatan = await getKecamatan(baseUrl)
  
  return (
    <main className="flex min-h-screen bg-gray-300 p-12">
      <div
        className="
          bg-white m-auto p-8 rounded-2xl shadow-lg flex flex-col
          items-center
        "
        style={{ width: "600px" }}
      >
        <h1 className="font-bold text-2xl">
          Daftar Akun <span className="text-accent">{webName}</span>
        </h1>

        <DaftarForm {...{listProvinsi, listKecamatan}} />
        <div className="flex">
          <p>Sudah punya akun bidan?</p>
          <Link href="/login" className="ml-2 text-accent underline">Masuk</Link>
        </div>
      </div>
    </main>
  )
}

async function getProvinsi(baseUrl?: string) {
  if (!baseUrl) return []
  const endpoint = `${baseUrl}/api/daerah/provinsi`
  const response = await fetch(endpoint)
  const data: Provinsi[] = (await response.json()).data
  return data
}
async function getKecamatan(baseUrl?: string) {
  if (!baseUrl) return []
  const endpoint = `${baseUrl}/api/daerah/kecamatan`
  const response = await fetch(endpoint)
  const data: Kecamatan[] = (await response.json()).data
  return data
}

export default DaftarPage