"use client"

import { useRouter } from "next/navigation"
import ElevatedButton from "../_components/elevated_button"
import { getAdminBaseUrl, themeColors } from "../_utils/constants"
import { ChangeEventHandler, FormEventHandler, useState } from "react"
import DaerahDropdown from "./daerah_dropdown"
import Swal from "sweetalert2"
import { v4 } from "uuid"

export interface Provinsi {
  id: string
  nama: string
}
export interface Kecamatan {
  id: string
  nama: string
  idProvinsi: string
}
interface DaftarFormProps {
  listProvinsi: Provinsi[]
  listKecamatan: Kecamatan[]
}
function DaftarForm({ listProvinsi, listKecamatan }: DaftarFormProps) {
  const router = useRouter()
  const [isLoading, setLoading] = useState(false)
  const [error, setError] = useState("")
  const [idProvinsi, setIdProvinsi] = useState(listProvinsi[0].id)

  const onDaftar: FormEventHandler<HTMLFormElement> = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError("")
    const formData = new FormData(e.currentTarget)
    const formEntries = Object.fromEntries(formData.entries())
    const endpoint = `${getAdminBaseUrl()}/request_daftar`
    const response = await fetch(endpoint, {
      method: "post",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify(formEntries)
    })
    setLoading(false)

    const jsonData = await response.json()
    if (response.status !== 201) {
      setError(jsonData.message)
      return
    }

    await Swal.fire({
      text: jsonData.message,
      icon: "success",
      confirmButtonColor: themeColors.primary
    });

    router.push("/login")
  }

  // TODO: validation

  const onSelectProvinsi: ChangeEventHandler<HTMLSelectElement> = (e) => {
    const newIdProvinsi = e.target.value
    setIdProvinsi(newIdProvinsi)
  }
  
  const listSelectedKecamatan = listKecamatan.filter((kecamatan) => {
    return kecamatan.idProvinsi === idProvinsi
  })
  
  return (
    <form
      onSubmit={onDaftar}
      className="flex flex-col w-full h-full px-8 pt-6 pb-12"
    >
      <p className="text-red-600 text-center">{error}</p>
      <input
        type="text"
        name="nama"
        id="nama"
        placeholder="Nama Bidan"
        required
      />
      <input
        type="text"
        name="email"
        id="email"
        placeholder="Email"
        required
      />
      <input
        type="password"
        name="password"
        id="password"
        placeholder="Kata Sandi"
        required
      />
      <input
        type="password"
        name="kpassword"
        id="kpassword"
        placeholder="Ulangi Kata Sandi"
        required
      />
      <input
        type="tel"
        name="noHp"
        id="noHp"
        placeholder="Nomor HP"
        required
      />
      <div className="py-2">
        <DaerahDropdown
          id="idProvinsi" label="Provinsi:"
          onChange={onSelectProvinsi} value={idProvinsi}
        >
          {listProvinsi.map((provinsi) => {
            const key = v4()
            return (
              <option
                key={key}
                value={provinsi.id}
              >
                {provinsi.nama}
              </option>
            )
          })}
        </DaerahDropdown>
        <DaerahDropdown
          id="idKecamatan" label="Kota / Kabupaten:"
        >
          {listSelectedKecamatan.map((kecamatan) => {
            const key = v4()
            return (
              <option
                key={key}
                value={kecamatan.id}
              >
                {kecamatan.nama}
              </option>
            )
          })}
        </DaerahDropdown>
      </div>
      <textarea
        name="alamat"
        id="alamat"
        placeholder="Alamat Lengkap"
        rows={3}></textarea>
      <textarea
        name="keterangan"
        id="keterangan"
        placeholder="Keterangan Bidan"
        rows={3}></textarea>

      <ElevatedButton
        type="submit"
        className="!bg-primary self-end mt-2 px-10"
        disabled={isLoading}
      >
        Daftar
      </ElevatedButton>
    </form>
  )
}

export default DaftarForm