const multer = require('multer')

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'images/')
  },
  filename: (req, file, cb) => {
    const date = Date.now()
    cb(null, `profil-${date}-${file.originalname}`)
  },
});

const uploadGambarProfil = multer({ storage }).single("file")

module.exports = uploadGambarProfil