// snack/components/CoinDisplay.js
import React from 'react';
import { View, Text } from 'react-native';

export default function CoinDisplay({ coins = 0 }) {
  return (
    <View style={{padding:12,backgroundColor:'#fff',borderRadius:8,shadowColor:'#000',elevation:2}}>
      <Text style={{fontSize:18,fontWeight:'600'}}>Coins: {coins}</Text>
    </View>
  );
}
