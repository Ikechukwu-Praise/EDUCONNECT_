// snack/components/TopicCard.js
import React from 'react';
import { TouchableOpacity, Text, View } from 'react-native';

export default function TopicCard({ title, onPress }) {
  return (
    <TouchableOpacity onPress={onPress} style={{padding:12,backgroundColor:'#fff',borderRadius:8,marginBottom:10}}>
      <Text style={{fontSize:16,fontWeight:'600'}}>{title}</Text>
    </TouchableOpacity>
  );
}
