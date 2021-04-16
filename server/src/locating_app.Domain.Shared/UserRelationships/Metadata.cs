using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Text;

namespace locating_app.UserRelationships
{
    public class Metadata
    {
        [BsonRepresentation(BsonType.String)]
        [BsonDefaultValue(Friendship.NORMAL)]
        public Friendship friendship { get; set; } 
    }
}
