// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MSIDWorkPlaceJoinConstants.h"

NSString *const kMSIDPrivateKeyIdentifier               = @"com.microsoft.workplacejoin.privatekey\0";
NSString *const kMSIDTenantKeyIdentifier                = @"com.microsoft.workplacejoin.tenantId";
NSString *const kMSIDUPNKeyIdentifier                   = @"com.microsoft.workplacejoin.registeredUserPrincipalName";
NSString *const kMSIDWPJThumbprintIdentifier            = @"com.microsoft.workplacejoin.thumbprint";
NSString *const kMSIDWPJCertificateCommonNameIdentifier = @"com.microsoft.workplacejoin.certificateCommonNameIdentifier";
NSString *const kMSIDWPJCloudEnvironmentIdentifier      = @"com.microsoft.workplacejoin.cloudEnvironment";
NSString *const kMSIDProtectionSpaceDistinguishedName   = @"MS-Organization-Access";
NSString *const kMSIDPKeyAuthUrn                        = @"urn:http-auth:PKeyAuth?";
// ADFS doesn't understand PKeyAuth+, so the client still needs to advertise PKeyAuth via user-agent.
// Keeping the header as x-ms-PKeyAuth+ and the user-agent as PKeyAuth/1.0 so that Pkeyauth challenges are provided by ADFS and PKeyAuth+ challenges are provided by ESTS.
NSString *const kMSIDPKeyAuthHeader                     = @"x-ms-PkeyAuth+";
NSString *const kMSIDPKeyAuthKeyWordForUserAgent        = @"PKeyAuth/1.0";
NSString *const kMSIDPKeyAuthHeaderVersion              = @"1.0";
NSString *const kMSIDWwwAuthenticateHeader              = @"WWW-Authenticate";
NSString *const kMSIDPKeyAuthName                       = @"PKeyAuth";
NSString *const kMSIDWPJKeychainGroupV2                 = @"com.microsoft.workplacejoin.v2";
