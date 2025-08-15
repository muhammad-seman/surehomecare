"use server"

import { cookies } from "next/headers"

export const getToken = async (): Promise<string | undefined> => {
  const cookieStore = await cookies()
  const token = cookieStore.get("TOKEN")
  return token?.value
}

export const getRole = async (): Promise<string | undefined> => {
  const cookieStore = await cookies()
  const role = cookieStore.get("ROLE")
  return role?.value
}

export const setToken = async (token: string, role: string) => {
  const cookieStore = await cookies()
  cookieStore.set("TOKEN", token)
  cookieStore.set("ROLE", role)
}

export const removeToken = async () => {
  const cookieStore = await cookies()
  cookieStore.delete("TOKEN")
  cookieStore.delete("ROLE")
}