const express = require("express")
const authentication = require("../middlewares/authentication")
const MessageController = require("../controllers/message_controller")
const router = express.Router()

router.get("/", authentication, MessageController.checkMessages)
router.get("/chatroom/:idOppose", authentication, MessageController.checkMessages)
router.get("/full_chatroom/:idOppose", authentication, MessageController.fullChatroomMessages)
router.get("/home", authentication, MessageController.homeMessages)
router.put("/read/:pengirim", authentication, MessageController.readMessage)
router.post("/send", authentication, MessageController.sendMessage)

module.exports = router