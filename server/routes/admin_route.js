const express = require("express")
const AdminController = require("../controllers/admin_controller")
const isAdmin = require("../middlewares/is_admin")
const router = express.Router()

router.get("/dashboard", isAdmin, AdminController.dashboardData)
router.get("/dashboard_bidan", isAdmin, AdminController.dashboardDataBidan)
router.get("/all_orders", isAdmin, AdminController.riwayatOrders)
router.get("/riwayat_pelayanan", isAdmin, AdminController.riwayatOrders)
router.get("/requests", isAdmin, AdminController.getDaftarRequests)
router.get("/requests/:id", isAdmin, AdminController.getDaftarRequests)
router.get("/all_bidan", isAdmin, AdminController.getDaftarBidan)
router.get("/all_user", isAdmin, AdminController.getDaftarUser)

router.post("/login", AdminController.loginAdmin)
router.post("/request_daftar", AdminController.requestDaftar)
router.put("/approve_request/:id", isAdmin, AdminController.approveDaftarRequest)
router.put("/decline_request/:id", isAdmin, AdminController.tolakDaftarRequest)
router.delete("/logout", isAdmin, AdminController.logout)

module.exports = router
