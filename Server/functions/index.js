
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
        res.status(400).send(`유저정보를 가져오는데 실패했습니다: ${error.message}`);
    }
});

groupingApp.post("/users", async (req, res) => {
    try {
        const userId = req.body.id;

        if (!userId) {
            return res.status(404).send("userId가 잘못됐습니다.");
        }

        const user = {
            id: req.body.id,
            nickName: req.body.nickName,
            followers: req.body.followers,
            following: req.body.following,
            email: req.body.email,
            profileImagePath: req.body.profileImagePath || null,
            birthDay: req.body.birthDay || null,
            phoneNumber: req.body.phoneNumber || null,
            gender: req.body.gender || null,
        };

        await db
            .collection("Users")
            .doc(userId)
            .set(user);

        res.status(200).json(user);
    } catch (error) {
        res.status(400).send(`유저를 생성하는데 실패했습니다: ${error.message}`);
    }
});

groupingApp.patch("/users/follow", async (req, res) => {
    const userId = req.query.userId;
    const followId = req.query.followId;

    if (!userId || !followId) {
        return res.status(404).send("userId가 잘못됐습니다")
    }

    try {
        const userDoc = await db
        .collection("Users")
        .doc(userId)
        .get();

        if (!userDoc) {
            return res.status(404).send("유저정보를 가져오는데 실패했습니다")
        }

        const userFollowers = userDoc.data().following || [];

        if (userFollowers.includes(followId)) {
            await db
                .collection("Users")
                .doc(userId)
                .update({
                    following: admin.firestore.FieldValue.arrayRemove(followId)
                })
            
            await db
                .collection("Users")
                .doc(followId)
                .update({
                    followers: admin.firestore.FieldValue.arrayRemove(userId)
                })

            res.status(200).json({ "isFollow": false })
        } else {
            await db
                .collection("Users")
                .doc(userId)
                .update({
                    following: admin.firestore.FieldValue.arrayUnion(followId)
                })
            
            await db
                .collection("Users")
                .doc(followId)
                .update({
                    followers: admin.firestore.FieldValue.arrayUnion(userId)
                })

            res.status(200).json({ "isFollow": true })
        }
    } catch (error) {
        res.status(400).send(`user를 follow 하는데 실패했습니다 ${error.message}`)
    }
});