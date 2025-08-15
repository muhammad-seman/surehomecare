export const webName = "iCare"

export const themeColors = {
  primary: "var(--primary)",
  secondary: "var(--secondary)",
  accent: "var(--accent)",
  background: "var(--background)",
  textPrimary: "var(--text-primary)",
}

export const getAdminBaseUrl = () => `${process.env.NEXT_PUBLIC_BACKEND_BASE_URL}/api/admin`
export const getImageBaseUrl = () => `${process.env.NEXT_PUBLIC_BACKEND_BASE_URL}/images`