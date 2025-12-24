import Link from "next/link"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Mail } from "lucide-react"

export default function SignUpSuccessPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-purple-50/20 p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="space-y-1 text-center">
          <div className="flex justify-center mb-4">
            <div className="rounded-full bg-primary/10 p-3">
              <Mail className="h-8 w-8 text-primary" />
            </div>
          </div>
          <CardTitle className="text-2xl font-bold">Check Your Email</CardTitle>
          <CardDescription>We've sent you a confirmation link to verify your account</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="bg-muted p-4 rounded-lg text-sm text-muted-foreground">
            <p className="mb-2">Please check your email and click the confirmation link to activate your account.</p>
            <p>Once confirmed, you'll be able to sign in and start using EduConnect.</p>
          </div>
          <Link href="/auth/login" className="block">
            <Button className="w-full">Go to Login</Button>
          </Link>
        </CardContent>
      </Card>
    </div>
  )
}
