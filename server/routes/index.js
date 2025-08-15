const { Router } = require("express")
const router = Router()

const userRouter = require("./user_route")
const bidanRouter = require("./bidan_route")
const layananRouter = require("./layanan_route")
const orderRouter = require("./order_route")
const messageRouter = require("./message_route")
const daerahRouter = require("./daerah_route")
const adminRouter = require("./admin_route")

router.use("/", userRouter)
router.use("/bidan", bidanRouter)
router.use("/layanan", layananRouter)
router.use("/order", orderRouter)
router.use("/message", messageRouter)
router.use("/daerah", daerahRouter)
router.use("/admin", adminRouter)

module.exports = router