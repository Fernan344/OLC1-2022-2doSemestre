import controller from '../controller/api.controller'
import express from 'express'
const router = express.Router();

router.get("/ping", controller.ping)
router.get("/index", controller.parse)

export default router;