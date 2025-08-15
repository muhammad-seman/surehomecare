import { getImageBaseUrl } from "../_utils/constants"

interface ProfilePictureProps {
  gambar: string | undefined
}
function ProfilePicture({ gambar }: ProfilePictureProps) {
  if (!gambar) {
    return (
      <p className="
        flex h-28 items-center text-neutral-500
        text-sm
      ">
        (Tidak ada gambar)
      </p>
    )
  }
  
  return (
    <img src={`${getImageBaseUrl()}/${gambar}`} className="w-28 h-28" />
  )
}

export default ProfilePicture