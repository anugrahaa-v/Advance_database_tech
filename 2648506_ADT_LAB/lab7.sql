// Lab 7: Demonstration of CRUD operations and Aggregate functions in MongoDB
// NOTE: This lab's code is MongoDB shell (mongosh) syntax, not SQL
// (extracted exactly as it appears in the manual).

show collections
// content
// payment
// subscription_plans
// user_subscriptions
// users
// watch_history

// ============================
// Insert one()
// ============================
db.content.insertOne({
    content_id: 501,
    title: "Stranger Things",
    genre: "Sci-Fi",
    type: "Series"
})
// {
//   acknowledged: true,
//   insertedId: ObjectId('6a7c0d5d334ed1382fa5566b')
// }

// ============================
// Insert many
// ============================
db.content.insertMany([
    {
        content_id: 502,
        title: "Extraction",
        genre: "Thriller",
        type: "Movie"
    },
    {
        content_id: 503,
        title: "Friends",
        genre: "Comedy",
        type: "Series"
    },
    {
        content_id: 504,
        title: "Interstellar",
        genre: "Sci-Fi",
        type: "Movie"
    },
])

// ============================
// READ OPERATIONS
// ============================

// find() — Display all content
db.content.find()

// findOne() — Find one content
db.content.findOne({
    content_id: 501
})

// find() with a filter
db.content.find({
    genre: "Sci-Fi"
})

// Another filter — Movies only
db.content.find({
    type: "Movie"
})

// Filter with selected fields
db.content.find(
    { genre: "Sci-Fi" },
    { _id: 0, title: 1, genre: 1 }
)

// ============================
// LOGICAL OPERATORS
// ============================

// $and
// We will find subscriptions where: status is Active AND plan ID is greater than or equal to 202
db.user_subscriptions.find({
    $and: [
        { status: "Active" },
        { plan_id: { $gte: 202 } }
    ]
})

// $or
// Find users whose name is Anugrahaa OR Priya
db.users.find({
    $or: [
        { name: "Anugrahaa" },
        { name: "Priya" }
    ]
})

// $not
// Find plans where the price is NOT greater than 400
db.subscription_plans.find({
    price: {
        $not: { $gt: 400 }
    }
})

// $nor
// Find subscriptions that are: NOT Expired AND NOT using Plan 203
db.user_subscriptions.find({
    $nor: [
        { status: "Expired" },
        { plan_id: 203 }
    ]
})

// ============================
// RELATIONAL OPERATORS
// ============================

// $gt — Greater Than
// Find plans with price greater than ₹300
db.subscription_plans.find({
    price: { $gt: 300 }
})

// $lt — Less Than
// Find plans with price less than ₹300
db.subscription_plans.find({
    price: { $lt: 300 }
})

// $eq — Equal To
// Find the plan whose price is exactly ₹399
db.subscription_plans.find({
    price: { $eq: 399 }
})

// $ne — Not Equal To
// Find plans whose price is not ₹399
db.subscription_plans.find({
    price: { $ne: 399 }
})

// $gte — Greater Than or Equal To
// Find plans costing ₹399 or more
db.subscription_plans.find({
    price: { $gte: 399 }
})

// $lte — Less Than or Equal To
// Find plans costing ₹399 or less
db.subscription_plans.find({
    price: { $lte: 399 }
})

// $in — Match Any Value in a List
// Find plans whose price is either ₹199 or ₹599
db.subscription_plans.find({
    price: { $in: [199, 599] }
})

// $nin — Not in a List
// Find plans whose price is neither ₹199 nor ₹599
db.subscription_plans.find({
    price: { $nin: [199, 599] }
})

// ============================
// UPDATE OPERATIONS
// ============================

// updateOne()
// Let's update Anugrahaa's email address in the users collection.
db.users.updateOne(
    { user_id: 101 },
    {
        $set: {
            email: "anugrahaa_updated@gmail.com"
        }
    }
)
db.users.findOne({
    user_id: 101
})

// updateMany()
// Let's add an auto_renew field to all Active subscriptions.
db.user_subscriptions.updateMany(
    { status: "Active" },
    {
        $set: {
            auto_renew: true
        }
    }
)
db.user_subscriptions.find({
    status: "Active"
})

// Update a nested value
db.users.updateOne(
    { user_id: 101 },
    {
        $set: {
            "address.city": "Coimbatore",
            "address.country": "India"
        }
    }
)
db.users.findOne({
    user_id: 101
})

// ============================
// DELETE OPERATIONS
// ============================

// deleteOne()
// We'll add one temporary OTT content record with a unique content_id.
db.content.insertOne({
    content_id: 999,
    title: "Test Movie",
    genre: "Test",
    type: "Movie"
})
db.content.deleteOne({
    content_id: 999
})
db.content.find({
    content_id: 999
})

// deleteMany()
db.content.insertMany([
    {
        content_id: 996,
        title: "Test Movie 1",
        genre: "Test",
        type: "Movie"
    },
    {
        content_id: 997,
        title: "Test Movie 2",
        genre: "Test",
        type: "Movie"
    }
])
db.content.deleteMany({
    genre: "Test"
})
db.content.find({
    genre: "Test"
})

// ============================
// AGGREGATION
// ============================

// $match
// $match filters documents before the next aggregation stage.
// Let's find only Active subscriptions.
db.user_subscriptions.aggregate([
    {
        $match: {
            status: "Active"
        }
    }
])

// $group
// Let's group your subscriptions based on plan_id
db.user_subscriptions.aggregate([
    {
        $group: {
            _id: "$plan_id",
            total_subscriptions: { $sum: 1 }
        }
    }
])

// $sum
// calculate the total payment amount.
db.payment.aggregate([
    {
        $group: {
            _id: null,
            total_revenue: { $sum: "$amount" }
        }
    }
])

// $avg
// Find the average payment amount.
db.payment.aggregate([
    {
        $group: {
            _id: null,
            average_payment: { $avg: "$amount" }
        }
    }
])

// $count
// Count the number of users.
db.users.aggregate([
    {
        $count: "total_users"
    }
])

// $project
// Let's display only the content title and genre.
db.content.aggregate([
    {
        $project: {
            _id: 0,
            title: 1,
            genre: 1
        }
    }
])

// $sort
// Let's sort subscription plans by price from highest to lowest.
db.subscription_plans.aggregate([
    {
        $sort: {
            price: -1
        }
    }
])

// $unwind
db.subscription_plans.updateOne(
    { plan_id: 201 },
    {
        $set: {
            features: ["HD", "1 Screen"]
        }
    }
)

db.subscription_plans.aggregate([
    {
        $match: {
            plan_id: 201
        }
    },
    {
        $unwind: "$features"
    },
    {
        $project: {
            _id: 0,
            plan_name: 1,
            features: 1
        }
    }
])

// $lookup
// We'll connect: user_subscriptions -> Users
db.user_subscriptions.aggregate([
    {
        $lookup: {
            from: "users",
            localField: "user_id",
            foreignField: "user_id",
            as: "user_details"
        }
    }
])
