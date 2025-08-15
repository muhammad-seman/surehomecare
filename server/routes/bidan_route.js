const express = require("express")
const authentication = require("../middlewares/authentication")
const BidanController = require("../controllers/bidan_controller")
const isBidan = require("../middlewares/is_bidan")
const router = express.Router()

router.get("/", authentication, BidanController.getBidanByKota)
router.get("/details/:idBidan", authentication, BidanController.getBidanDetails)
router.get("/search/:search", authentication, BidanController.searchBidan)
router.get("/recent", authentication, BidanController.recentBidan)
router.put("/profile", authentication, isBidan, BidanController.updateProfilBidan)
router.get("/statistik", authentication, isBidan, BidanController.getStatistics)
router.put("/kesediaan/:bersedia", authentication, isBidan, BidanController.updateKesediaan)
router.get("/favorite", authentication, BidanController.allFavoriteBidan)
router.put("/favorite/:idBidan", authentication, BidanController.setFavoriteBidan)

module.exports = router