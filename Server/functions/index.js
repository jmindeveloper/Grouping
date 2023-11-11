
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');

admin.initializeApp();

const app = express();
const groupingApp = express.Router()

const db = admin.firestore();

app.use(express.json());
app.use("/api", groupingApp);

exports.groupingApp = functions.region("asia-northeast3").https.onRequest(app);

// groupingApp.get("/users", async (req, res) => {
//     try {
//         const userDoc = await db
//             .collection("Users")
//             .doc(req.query.userId)
//             .get();

//             res.status(200).send({ id: userDoc.id })
//     } catch (error) {
//         console.log(error)
//         res.status(400).send("유저정보를 가져오는데 실패했습니다.");
//     }
// });

groupingApp.get("/users", async (req, res) => {
    try {
        const userId = req.query.userId;

        if (!userId) {
            return res.status(400).send("userId가 제공되지 않았습니다.");
        }

        const userDoc = await db
            .collection("Users")
            .doc(userId)
            .get();

        if (!userDoc.exists) {
            res.send(404).send("유저정보를 가져오는데 실패했습니다");
            return
        }

        res.status(200).send({ id: userDoc.id, ...userDoc.data() });
    } catch (error) {
        res.status(400).send("유저정보를 가져오는데 실패했습니다: ${error.message}");
    }
});
