// snack/screens/ProfileScreen.js
import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import CoinDisplay from '../components/CoinDisplay';

export default function ProfileScreen({ navigate }) {
  return (
    <View style={{padding:20}}>
      <Text style={{fontSize:22,fontWeight:'700',marginBottom:12'}}>Profile</Text>
      <CoinDisplay coins={20} />

      <TouchableOpacity onPress={() => navigate('home')} style={{marginTop:12}}>
        <Text style={{color:'#999'}}>Back</Text>
      </TouchableOpacity>
    </View>
  );
}
