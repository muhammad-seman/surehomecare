"use client"

import { useRouter } from "next/navigation"
import ElevatedButton from "../_components/elevated_button"
import { getAdminBaseUrl } from "../_utils/constants"
import { setToken } from "../_actions/auth"
import { FormEventHandler, useState } from "react"

function LoginForm() {
  const router = useRouter()
  const [isLoading, setLoading] = useState(false)
  const [error, setError] = useState("")
  
  const onLogin: FormEventHandler<HTMLFormElement> = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError("")
    const formData = new FormData(e.currentTarget)
    const formEntries = Object.fromEntries(formData.entries())

    const endpoint = `${getAdminBaseUrl()}/login`
    const response = await fetch(endpoint, {
      method: "post",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify(formEntries)
    })
    setLoading(false)

    const jsonData = await response.json()
    if (response.status !== 200) {
      setError(jsonData.message)
      return
    }

    const data = jsonData.data
    const token = data.token
    const role = data.role
    await setToken(token, role)
    router.push("/")
  }
  
  return (
    <form
      onSubmit={onLogin}
      className="flex flex-col w-96 h-full pt-6 pb-12"
    >
      <p className="text-red-600 text-center">{error}</p>
      <input
        type="text"
        name="email"
        id="email"
        placeholder="Email / Username"
        required
        />
      <input
        type="password"
        name="password"
        id="password"
        placeholder="Kata Sandi"
        required
      />
      <ElevatedButton
        type="submit"
        className="!bg-primary self-end mt-2 px-10"
        disabled={isLoading}
      >
        Masuk
      </ElevatedButton>
    </form>
  )
}

export default LoginForm