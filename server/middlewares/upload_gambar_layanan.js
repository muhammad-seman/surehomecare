const multer = require('multer')

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'images/')
  },
  filename: (req, file, cb) => {
    const date = Date.now()
    cb(null, `layanan-${date}-${file.originalname}`)
  },
});

const uploadGambarLayanan = multer({ storage }).single("file")

module.exports = uploadGambarLayanan