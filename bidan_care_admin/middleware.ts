import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'
import { bidanNavbars } from './app/_data/navbars'

async function isLoggedIn() {
  const cookieStore = await cookies();
  const token = cookieStore.get("TOKEN");
  if (token) return true
  return false
}

async function isBidan() {
  const cookieStore = await cookies()
  const role = cookieStore.get("ROLE")
  if (role?.value === "bidan") return true
  return false
}
 
export async function middleware(request: NextRequest) {
  if (!(await isLoggedIn())) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  const pathname = request.nextUrl.pathname
  if (await isBidan() && pathname === "/") {
    return NextResponse.rewrite(new URL('/dashboard_bidan', request.url))
  }

  const bidanHrefs = bidanNavbars.map((navbar) => navbar.href)
  if (await isBidan() && !bidanHrefs.includes(pathname)) {
    return NextResponse.redirect(new URL('/', request.url))
  }
}

export const config = {
  matcher: [
    '/((?!api|login|daftar|_next/static|_next/image|favicon.ico).*)',
  ],
}