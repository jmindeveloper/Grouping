
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const status = require('statuses');
const { async } = require('@firebase/util');

admin.initializeApp();

const app = express();
const groupingApp = express.Router()

const db = admin.firestore();

app.use(express.json());
app.use("/api", groupingApp);

exports.groupingApp = functions.region("asia-northeast3").https.onRequest(app);

// MARK: - Utills
function dateToString(date) {
    return date.toISOString().replace(/\.\d{3}Z$/, 'Z');
}

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

// getUserPosts
groupingApp.get("/users/posts", async (req, res) => {
    const userId = req.query.userId;

    if (!userId) {
        return res.status(400).send("userId가 제공되지 않았습니다.");
    }

    try {
        const posts = (await db.collection("Users").doc(userId).collection("Post").doc("Post").get()).data().posts;
        const matchingPosts = await db.collection("Post").where(admin.firestore.FieldPath.documentId(), 'in', posts).get();
        
        const postsData = matchingPosts.docs.map(doc => {
            const data = doc.data();

            if (data.createdAt instanceof admin.firestore.Timestamp) {
                data.createdAt = dateToString(data.createdAt.toDate());
            }
        
            if (data.updatedAt instanceof admin.firestore.Timestamp) {
                data.updatedAt = dateToString(data.updatedAt.toDate());
            }

            return data;
        });
        
        res.status(200).json(postsData)
    } catch (error) {
        return res.status(404).send(`post를 가져오는데 실패했습니다 ${error}`);
    }
});

// MARK: - Post
// upload post
groupingApp.post("/posts", async (req, res) => {
    const postId = req.body.id;
    const createUserId = req.query.createUserId;

    if (!createUserId) {
        return res.status(400).send("createUserId가 잘못됐습니다");
    }
    if (!postId) {
        return res.status(400).send("postId가 잘못됐습니다");
    }

    const createdAt = new Date(req.body.createdAt);
    const updatedAt = req.body.updatedAt ? new Date(req.body.updatedAt) : null;

    if (isNaN(createdAt.getTime())) {
        return res.status(400).send("올바르지 않은 createdAt 값입니다");
    }
    
    if (updatedAt && isNaN(updatedAt.getTime())) {
        return res.status(400).send("올바르지 않은 updatedAt 값입니다");
    }

    const post = {
        id: req.body.id,
        createUserId: req.body.createUserId,
        images: req.body.images,
        content: req.body.content,
        createdAt: createdAt,
        updatedAt: updatedAt,
        location: req.body.location || null,
        heartUsers: req.body.heartUsers,
        commentCount: req.body.commentCount,
        tags: req.body.tags,
        groupId: req.body.groupId || null
    };

    try {
        await db.collection("Post").doc(postId).set(post);

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
        res.status(400).send(`Post 업로드에 실패했습니다: ${error.message}`);
    }
});

// delete post
groupingApp.delete("/posts", async (req, res) => {
    const postId = req.query.postId;
    const userId = req.query.userId;
    
    if (!postId) {
        return res.status(400).send("postId가 잘못됐습니다.");
    }

    if (!userId) {
        return res.status(400).send("userId가 잘못됐습니다.");
    }

    try {

        const post = await (await db.collection("Post").doc(postId).get()).data();
        const createUserId = post.createUserId;
        const groupId = post.groupId;

        if (createUserId !== userId) {
            return res.status(400).send("user의 삭제권한이 없습니다.");
        }

        await db.collection("Post").doc(postId).delete();

        await db
            .collection("Users")
            .doc(createUserId)
            .collection("Post")
            .doc("Post")
            .update({
                posts: admin.firestore.FieldValue.arrayRemove(postId)
            });

        if (groupId) {
            await db
                .collection("Group")
                .doc(groupId)
                .update({
                    posts: admin.firestore.FieldValue.arrayRemove(postId)
                }); 
        }

        res.status(200).send("게시물이 성공적으로 삭제되었습니다.");
    } catch (error) {
        res.status(404).send(`게시물 삭제 중 오류가 발생했습니다. ${error}`);
    }
});

// update post
groupingApp.put("/posts", async (req, res) => {

});

// Mark: - Group
// getGroupPosts
groupingApp.get("/groups/posts", async (req, res) => {
    const groupId = req.query.groupId;

    if (!groupId) {
        return res.status(400).send("groupId가 제공되지 않았습니다.");
    }

    try {
        const posts = (await db.collection("Group").doc(groupId).get()).data().posts;
        const matchingPosts = await db.collection("Post").where(admin.firestore.FieldPath.documentId(), 'in', posts).get();
        
        const postsData = matchingPosts.docs.map(doc => {
            const data = doc.data();

            if (data.createdAt instanceof admin.firestore.Timestamp) {
                data.createdAt = dateToString(data.createdAt.toDate());
            }
        
            if (data.updatedAt instanceof admin.firestore.Timestamp) {
                data.updatedAt = dateToString(data.updatedAt.toDate());
            }

            return data;
        });
        
        res.status(200).json(postsData)
    } catch (error) {
        return res.status(404).send(`post를 가져오는데 실패했습니다 ${error}`);
    }
});