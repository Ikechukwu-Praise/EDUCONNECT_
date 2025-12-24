// snack/App.js
import React, { useState } from 'react';
import { SafeAreaView } from 'react-native';
import HomeScreen from './screens/HomeScreen';
import SignInScreen from './screens/SignInScreen';
import SignUpScreen from './screens/SignUpScreen';
import SubjectsScreen from './screens/SubjectsScreen';
import ResourcesScreen from './screens/ResourcesScreen';
import StudyRoomScreen from './screens/StudyRoomScreen';
import ProfileScreen from './screens/ProfileScreen';

export default function App() {
  const [route, setRoute] = useState('home');
  const nav = (r) => setRoute(r);

  return (
    <SafeAreaView style={{flex:1}}>
      {route === 'home' && <HomeScreen navigate={nav} />}
      {route === 'signin' && <SignInScreen navigate={nav} />}
      {route === 'signup' && <SignUpScreen navigate={nav} />}
      {route === 'subjects' && <SubjectsScreen navigate={nav} />}
      {route === 'resources' && <ResourcesScreen navigate={nav} />}
      {route === 'studyroom' && <StudyRoomScreen navigate={nav} />}
      {route === 'profile' && <ProfileScreen navigate={nav} />}
    </SafeAreaView>
  );
}
