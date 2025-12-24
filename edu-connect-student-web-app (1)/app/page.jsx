import Link from "next/link"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { BookOpen, Users, Coins, Upload, Download, MessageSquare } from "lucide-react"

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-background to-purple-50/20">
      {/* Header */}
      <header className="border-b bg-background/95 backdrop-blur supports-backdrop-filter:bg-background/60">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <BookOpen className="h-8 w-8 text-primary" />
            <span className="text-2xl font-bold bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent">
              EduConnect
            </span>
          </div>
          <div className="flex items-center gap-3">
            <Link href="/auth/login">
              <Button variant="ghost">Login</Button>
            </Link>
            <Link href="/auth/sign-up">
              <Button>Get Started</Button>
            </Link>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-20 text-center">
        <div className="max-w-3xl mx-auto space-y-6">
          <h1 className="text-5xl md:text-6xl font-bold leading-tight text-balance">
            Your Academic Success,{" "}
            <span className="bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent">Connected</span>
          </h1>
          <p className="text-xl text-muted-foreground text-pretty max-w-2xl mx-auto">
            Join thousands of students sharing resources, collaborating in study rooms, and achieving academic
            excellence together.
          </p>
          <div className="flex gap-4 justify-center pt-4">
            <Link href="/auth/sign-up">
              <Button size="lg" className="text-lg h-12 px-8">
                Join for Free
              </Button>
            </Link>
            <Link href="/auth/login">
              <Button size="lg" variant="outline" className="text-lg h-12 px-8 bg-transparent">
                Sign In
              </Button>
            </Link>
          </div>
        </div>
      </section>

      {/* Features Grid */}
      <section className="container mx-auto px-4 py-16">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold mb-3">Everything You Need to Succeed</h2>
          <p className="text-muted-foreground text-lg">Powerful features designed for student collaboration</p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-6xl mx-auto">
          <Card className="border-2 hover:border-primary/50 transition-colors">
            <CardContent className="pt-6">
              <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                <BookOpen className="h-6 w-6 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Browse Subjects</h3>
              <p className="text-muted-foreground">
                Access resources across 8 major subjects including Computer Science, Mathematics, Physics, and more.
              </p>
            </CardContent>
          </Card>

          <Card className="border-2 hover:border-primary/50 transition-colors">
            <CardContent className="pt-6">
              <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                <Upload className="h-6 w-6 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Upload Resources</h3>
              <p className="text-muted-foreground">
                Share your notes, assignments, and study materials. Earn coins for every resource you upload.
              </p>
            </CardContent>
          </Card>

          <Card className="border-2 hover:border-primary/50 transition-colors">
            <CardContent className="pt-6">
              <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                <Download className="h-6 w-6 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Download Materials</h3>
              <p className="text-muted-foreground">
                Access high-quality resources from your peers. Use coins to download materials you need.
              </p>
            </CardContent>
          </Card>

          <Card className="border-2 hover:border-primary/50 transition-colors">
            <CardContent className="pt-6">
              <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                <Coins className="h-6 w-6 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Coin System</h3>
              <p className="text-muted-foreground">
                Start with 50 free coins. Earn more by uploading or purchase additional coins as needed.
              </p>
            </CardContent>
          </Card>

          <Card className="border-2 hover:border-primary/50 transition-colors">
            <CardContent className="pt-6">
              <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                <Users className="h-6 w-6 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Study Rooms</h3>
              <p className="text-muted-foreground">
                Create or join study rooms with classmates. Collaborate in real-time on specific subjects.
              </p>
            </CardContent>
          </Card>

          <Card className="border-2 hover:border-primary/50 transition-colors">
            <CardContent className="pt-6">
              <div className="rounded-full w-12 h-12 bg-primary/10 flex items-center justify-center mb-4">
                <MessageSquare className="h-6 w-6 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Student Community</h3>
              <p className="text-muted-foreground">
                Connect with peers from your university. Share knowledge and grow together.
              </p>
            </CardContent>
          </Card>
        </div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-4 py-16">
        <Card className="bg-gradient-to-r from-primary/10 via-purple-50/50 to-primary/10 border-2 border-primary/20">
          <CardContent className="py-12 text-center">
            <h2 className="text-3xl font-bold mb-4">Ready to Boost Your Studies?</h2>
            <p className="text-muted-foreground text-lg mb-6 max-w-2xl mx-auto">
              Join EduConnect today and get instant access to thousands of educational resources shared by students like
              you.
            </p>
            <Link href="/auth/sign-up">
              <Button size="lg" className="text-lg h-12 px-8">
                Create Free Account
              </Button>
            </Link>
          </CardContent>
        </Card>
      </section>

      {/* Footer */}
      <footer className="border-t mt-16">
        <div className="container mx-auto px-4 py-8 text-center text-muted-foreground">
          <p>&copy; 2025 EduConnect. Built for students, by students.</p>
        </div>
      </footer>
    </div>
  )
}
