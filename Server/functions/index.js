
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const status = require('statuses');

admin.initializeApp();

const app = express();
const groupingApp = express.Router()

const db = admin.firestore();

app.use(express.json());
app.use("/api", groupingApp);

exports.groupingApp = functions.region("asia-northeast3").https.onRequest(app);

// MARK: - User
// get User
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
            res.status(404).send("유저정보를 가져오는데 실패했습니다");
            return
        }

        res.status(200).send({ id: userDoc.id, ...userDoc.data() });
    } catch (error) {
        res.status(400).send(`유저정보를 가져오는데 실패했습니다: ${error.message}`);
    }
});

// create User
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

        db
            .collection("Users")
            .doc(userId)
            .collection("Post")
            .doc("Post")
            .set({ "posts": [] })

        db
            .collection("Users")
            .doc(userId)
            .collection("Group")
            .doc("Group")
            .set({ "groups": [] })

        db
            .collection("Users")
            .doc(userId)
            .collection("StarGroup")
            .doc("StarGroup")
            .set({ "starGroups": [] })

        db
            .collection("Users")
            .doc(userId)
            .collection("StarPost")
            .doc("StarPost")
            .set({ "starPosts": [] })

        res.status(200).json(user);
    } catch (error) {
        res.status(400).send(`유저를 생성하는데 실패했습니다: ${error.message}`);
    }
});

// follow
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

// MARK: - Post

// upload post
groupingApp.post("/posts", async (req, res) => {
    const postId = req.body.id;
    const createUserId = req.query.createUserId;

    if (!createUserId) {
        return res.status(404).send("createUserId가 잘못됐습니다");        
    }
    if (!postId) {
        return res.status(404).send("postId가 잘못됐습니다");
    }

    const post = {
        id: req.body.id,
        createUserId: req.body.createUserId,
        images: req.body.images,
        content: req.body.content,
        createdAt: req.body.createdAt,
        updatedAt : req.body.updatedAt || null,
        location: req.body.location || null,
        heartUsers: req.body.heartUsers,
        commentCount: req.body.commentCount,
        tags: req.body.tags,
        groupId: req.body.groupId || null
    };

    try {
        await db
        .collection("Post")
        .doc(postId)
        .set(post);

        await db
            .collection("Users")
            .doc(createUserId)
            .collection("Post")
            .doc("Post")
            .update({
                posts: admin.firestore.FieldValue.arrayUnion(postId)
            });

        res.status(200).json(post);
    } catch (error) {
        res.status(404).send(`Post 업로드에 실패했습니다 ${error.message}`);
    }
});