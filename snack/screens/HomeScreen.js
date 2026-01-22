// snack/screens/HomeScreen.js
import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import CoinDisplay from '../components/CoinDisplay';
import { supabase } from '../lib/supabase';

export default function HomeScreen({ navigate }) {
  const [user, setUser] = useState(null);
  const [coins, setCoins] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      try {
        const { data: { user: authUser } } = await supabase.auth.getUser();
        if (authUser && mounted) {
          setUser(authUser);
          const { data: profile } = await supabase.from('profiles').select('coins').eq('id', authUser.id).single();
          if (profile && mounted) setCoins(profile.coins || 0);
        }
      } catch (err) {
        console.warn(err);
      } finally { if (mounted) setLoading(false); }
    };
    load();
    return () => { mounted = false; };
  }, []);

  return (
    <ScrollView contentContainerStyle={{padding:20}}>
      <Text style={{fontSize:28,fontWeight:'700',marginBottom:12}}>EduConnect</Text>
      
      {loading && <ActivityIndicator />}
      {user ? (
        <>
          <Text style={{fontSize:16,marginBottom:8}}>Welcome, {user.email}!</Text>
          <CoinDisplay coins={coins} />
          
          <TouchableOpacity onPress={() => navigate('subjects')} style={{marginTop:20,backgroundColor:'#7c3aed',padding:12,borderRadius:8}}>
            <Text style={{color:'#fff',textAlign:'center'}}>Browse Subjects</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => navigate('studyroom')} style={{marginTop:10,backgroundColor:'#3b82f6',padding:12,borderRadius:8}}>
            <Text style={{color:'#fff',textAlign:'center'}}>Study Rooms</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => navigate('profile')} style={{marginTop:10,backgroundColor:'#ec4899',padding:12,borderRadius:8}}>
            <Text style={{color:'#fff',textAlign:'center'}}>Profile</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={async () => { await supabase.auth.signOut(); setUser(null); }} style={{marginTop:20}}>
            <Text style={{color:'#666'}}>Sign Out</Text>
          </TouchableOpacity>
        </>
      ) : (
        <>
          <Text style={{marginBottom:12,color:'#666'}}>Sign in or create an account to get started.</Text>
          
          <TouchableOpacity onPress={() => navigate('signin')} style={{backgroundColor:'#7c3aed',padding:12,borderRadius:8}}>
            <Text style={{color:'#fff',textAlign:'center'}}>Sign In</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => navigate('signup')} style={{marginTop:10,backgroundColor:'#3b82f6',padding:12,borderRadius:8}}>
            <Text style={{color:'#fff',textAlign:'center'}}>Sign Up</Text>
          </TouchableOpacity>
        </>
      )}
    </ScrollView>
  );
}
