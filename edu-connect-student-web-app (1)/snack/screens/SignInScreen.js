// snack/screens/SignInScreen.js
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity } from 'react-native';
import { supabase } from '../lib/supabase';

export default function SignInScreen({ navigate }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  return (
    <View style={{padding:20}}>
      <Text style={{fontSize:24,fontWeight:'700',marginBottom:12}}>Sign In</Text>
      <TextInput placeholder="Email" value={email} onChangeText={setEmail} style={{borderWidth:1,borderColor:'#ddd',padding:8,borderRadius:6,marginBottom:10}} />
      <TextInput placeholder="Password" secureTextEntry value={password} onChangeText={setPassword} style={{borderWidth:1,borderColor:'#ddd',padding:8,borderRadius:6,marginBottom:10}} />

      <TouchableOpacity onPress={async () => {
        try {
          const { data, error } = await supabase.auth.signInWithPassword({ email, password });
          if (error) return alert(error.message || 'Sign-in error');
          alert('Signed in successfully');
          navigate('home');
        } catch (err) {
          alert('Sign-in failed');
        }
      }} style={{backgroundColor:'#7c3aed',padding:12,borderRadius:8}}>
        <Text style={{color:'#fff',textAlign:'center'}}>Sign In</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => navigate('signup')} style={{marginTop:12}}>
        <Text style={{color:'#7c3aed'}}>Create an account</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => navigate('home')} style={{marginTop:12}}>
        <Text style={{color:'#999'}}>Back</Text>
      </TouchableOpacity>
    </View>
  );
}
