// snack/components/ResourceCard.js
import React from 'react';
import { TouchableOpacity, Text, View } from 'react-native';

export default function ResourceCard({ title, coins, onPress }) {
  return (
    <TouchableOpacity onPress={onPress} style={{padding:12,backgroundColor:'#fff',borderRadius:8,marginBottom:10,flexDirection:'row',justifyContent:'space-between',alignItems:'center'}}>
      <Text style={{fontSize:16}}>{title}</Text>
      <Text style={{fontSize:14,color:'#666'}}>{coins} coin{coins>1?'s':''}</Text>
    </TouchableOpacity>
  );
}
