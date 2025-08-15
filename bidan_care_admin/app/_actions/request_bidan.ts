import { getAdminBaseUrl } from "../_utils/constants"
import { getToken } from "./auth"

export const tolakRequest = async (id: string): Promise<boolean> => {
  const token = await getToken()
  const endpoint = `${getAdminBaseUrl()}/decline_request/${id}`
  const response = await fetch(endpoint, {
    method: "put",
    headers: {"Authorization": `Bearer ${token}`}
  })
  if (response.status === 200) return true
  console.log(await response.json())
  return false
}

export const terimaRequest = async (id: string): Promise<boolean> => {
  const token = await getToken()
  const endpoint = `${getAdminBaseUrl()}/approve_request/${id}`
  const response = await fetch(endpoint, {
    method: "put",
    headers: {"Authorization": `Bearer ${token}`}
  })
  if (response.status === 201) return true
  console.log(await response.json())
  return false
}