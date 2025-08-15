import Link from "next/link"
import LoginForm from "./login_form"
import { webName } from "../_utils/constants"

async function LoginPage() {
  return (
    <main className="flex h-screen bg-gray-300">
      <div
        className="
          bg-white m-auto p-8 rounded-2xl shadow-lg flex flex-col
          items-center
        "
        style={{ width: "500px" }}
      >
        <h1 className="font-bold text-2xl">
          <span className="text-accent">{webName}</span> Admin
        </h1>

        <LoginForm />
        <div className="flex">
          <p>Mau daftar sebagai bidan?</p>
          <Link href="/daftar" className="ml-2 text-accent underline">Daftar</Link>
        </div>
      </div>
    </main>
  )
}

export default LoginPage